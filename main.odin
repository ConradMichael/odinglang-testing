package main

import "core:fmt"
import SDL "vendor:sdl2"

WINDOW_TITLE :: "My Game Title"
WINDOW_X : i32 = SDL.WINDOWPOS_CENTERED
WINDOW_Y : i32 = SDL.WINDOWPOS_CENTERED
WINDOW_W : i32 = 1200
WINDOW_H : i32 = 1000

WINDOW_FLAGS :: SDL.WINDOW_RESIZABLE

main :: proc() {
    fmt.println("Hellope!")

    SDL.Init(SDL.INIT_VIDEO)
    window := SDL.CreateWindow(WINDOW_TITLE, WINDOW_W, WINDOW_Y, WINDOW_W, WINDOW_H, WINDOW_FLAGS)

    event : SDL.Event

    game_loop: for {
        if SDL.PollEvent(&event) {
            if event.type == SDL.EventType.QUIT {
                break game_loop
            }
        }
    }

    SDL.DestroyWindow(window)
    SDL.Quit()
}
