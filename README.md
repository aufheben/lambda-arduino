λ-arduino is a framework for building beautiful web interfaces for Arduino. The aim of this project is to make IoT development with Arduino easier and more enjoyable.

---

## How to test

λ-arduino uses the Firmata protocol to communicate with the device. Therefore the first step is to get Firmata running on the board.

1. Connect Arduino to the USB port and launch Arduino IDE, choose correct board and port from "Tools"
1. Open "File -> Examples -> Firmata -> StandardFirmata"
1. Upload the program to the board

## How to build

λ-arduino is written in Haskell with the high-powered [Yesod](http://www.yesodweb.com/) web framework. To build it you need [stack](http://docs.haskellstack.org/en/stable/README/), the Haskell build tool. Follow the [instructions](http://docs.haskellstack.org/en/stable/install_and_upgrade/) to install stack.

Then, follow the [Yesod quick start guide](http://www.yesodweb.com/page/quickstart):

1. Fetch the source code: `git clone https://github.com/aufheben/lambda-arduino.git && cd lambda-arduino`
1. Install the yesod command line tool: `stack install yesod-bin cabal-install --install-ghc`
1. Build libraries: `stack build`
1. Launch devel server: `stack exec -- yesod devel`. On Linux you need to be root to access the /dev/ttyUSBX device, therefore use `sudo stack exec --allow-different-user -- yesod devel`
1. View the site at http://localhost:3000/

---

Known problems:

1. The pin mode can only be switched to PWM once

---

Future work:

1. Use Websocket to communicate with the web server instead of AJAX ("SJAX" actually).
2. Run Firmata on the client-side with Javascript, and be able to switch mode from server-side
   and client-side Firmata
3. Building interfaces for servo motors, LCD displays, keypads, and more
