package main

import "core:fmt"
import "core:math/linalg"
import SDL "vendor:sdl2"
import SDL_IMG "vendor:sdl2/image"

Game :: struct {
	renderer: ^SDL.Renderer,
	keyboard: []u8,
	time:     f64,
	dt:       f64,
	entities: [dynamic]Entity,
}

SpriteType :: enum {
    GRASS,
}

Sprite :: struct {
    type: SpriteType,
    image: cstring,
    x: i32,
    y: i32,
}

EntityType :: enum {
	PLAYER,
	ENEMY,
}

Entity :: struct {
	type:           EntityType,
	hp:             int,
	pos:            [2]f32,
}

render_sprite :: proc(sprite: ^Sprite, game: ^Game) {
    switch sprite.type {
    case .GRASS:
        img := SDL_IMG.Load(sprite.image)
        if img == nil {
            fmt.print("Couldn't load %v.", sprite.image)
            return
        }
        defer SDL.FreeSurface(img)

        texture := SDL.CreateTextureFromSurface(game.renderer, img)
        if texture == nil {
            fmt.print("Couldn't create texture from %v.", sprite.image)
            return
        }
        defer SDL.DestroyTexture(texture)

        sdlRect := SDL.Rect{
            x = sprite.x,
            y = sprite.y,
            w = img.w,
            h = img.h,
        }

        SDL.RenderCopy(game.renderer, texture, nil, &sdlRect)
    }
}

get_time :: proc() -> f64 {
	return f64(SDL.GetPerformanceCounter()) * 1000 / f64(SDL.GetPerformanceFrequency())
}

main :: proc() {
	assert(SDL.Init(SDL.INIT_VIDEO) == 0, SDL.GetErrorString())

    img_init_flags := SDL_IMG.INIT_PNG
    img_res        := SDL_IMG.InitFlags(SDL_IMG.Init(img_init_flags))

	defer SDL.Quit()

	window := SDL.CreateWindow(
		"Odin Game",
		SDL.WINDOWPOS_CENTERED,
		SDL.WINDOWPOS_CENTERED,
		640,
		480,
		SDL.WINDOW_SHOWN,
	)
	assert(window != nil, SDL.GetErrorString())
	defer SDL.DestroyWindow(window)

	renderer := SDL.CreateRenderer(window, -1, SDL.RENDERER_ACCELERATED)
	assert(renderer != nil, SDL.GetErrorString())
	defer SDL.DestroyRenderer(renderer)

	tickrate := 240.0
	ticktime := 1000.0 / tickrate

	game := Game {
		renderer = renderer,
		time     = get_time(),
		dt       = ticktime,
		entities = make([dynamic]Entity),
	}
	defer delete(game.entities)

	append(&game.entities, Entity{type = .PLAYER, pos = { 50.0, 400.0}, hp = 10})

    grass := Sprite{
        type = .GRASS,
        image = "./resources/Grass.png",
        x = 64,
        y = 64,
    }

	dt := 0.0

	for {
		event: SDL.Event

		for SDL.PollEvent(&event) {
			#partial switch event.type {
			case .QUIT:
				return
            // case .MOUSEBUTTONDOWN:
            //     fmt.print(event.key)
			case .KEYDOWN:
                fmt.print(event.key.keysym)
				if event.key.keysym.scancode == SDL.SCANCODE_ESCAPE {
					return
				}
			}
		}

		time := get_time()
		dt += time - game.time

		game.keyboard = SDL.GetKeyboardStateAsSlice()
		game.time = time

		for dt >= ticktime {
			dt -= ticktime
		}

        SDL.SetRenderDrawColor(renderer, 255, 255, 255, 255)
        render_sprite(&grass ,&game)
		SDL.RenderClear(renderer)
        render_sprite(&grass ,&game)
		SDL.RenderPresent(renderer)
	}
}
