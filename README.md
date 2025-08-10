# FLAPPY BIRD - Assembly Game

This project is an implementation of a classic Flappy Bird-style game written in x86 Assembly language. The game runs in a simple text-based mode, utilizing BIOS interrupts for graphics and user input.

## Features

  * **Start Menu:** A visually-enhanced start menu with options to play the game, view instructions, see developer information, and exit.

  * **ASCII Art:** The main menu and game screens feature custom ASCII art borders and a title.

  * **Game Play:**

      * Control a "bird" to fly up and down.

      * Avoid collisions with obstacles.

      * Score points by surviving.

  * **Pause Functionality:** The game can be paused at any time by pressing the `ESC` key.

  * **Game Over Screen:** Displays the final score and an option to return to the main menu.

  * **Instructions and Credits:** Dedicated screens for game instructions and project developer information.

## How to Run

To run this program, you will need an assembler and a DOS environment emulator.

1.  **Assemble the code:**
    Use an assembler like NASM or MASM to assemble the `ProjFB.asm` file into an executable binary (e.g., a `.com` file).

    ```
    nasm ProjFB.asm -o ProjFB.com

    ```

    or

    ```
    ml ProjFB.asm

    ```

2.  **Run the executable:**
    Execute the generated `.com` file in a DOS environment (like DOSBox or a virtual machine).

    ```
    ProjFB.com

    ```

## Controls

  * **Main Menu:**

      * `1`: Play Game

      * `2`: Information

      * `3`: Project Group

      * `4`: Exit Game

  * **In-Game:**

      * `Arrow Up`: Move the bird up.

      * `Release Arrow Up`: The bird will automatically descend.

      * `ESC`: Pause the game.

  * **Pause Menu:**

      * `Y`: Exit the game to the main menu.

      * `N`: Resume the game.

  * **Game Over Screen:**

      * `Any Key`: Return to the main menu.

## Developers

  * Umer Mujahid (23L-0774)

  * M. Basim Irfan (23L-0846)

Batch: BCS-3J-23
