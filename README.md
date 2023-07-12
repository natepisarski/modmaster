# modmaster
Modmaster is an early version of [Kast](https://github.com/natepisarski/kast), written in Haskell. It is essentially a queue with workers, but each worker is a separate binary program on the system.

You define rules ahead of time, which tells it how to react to **signals**. **Signals** can be dispatched from any binary program over port `5382`, in the format `module:signal`.

Your listener can do anything with the `signal`, including firing its own `signals`, allowing you to build a network of event handlers.

# Features
### Modal server executable
The Modmaster server is the modmaster client program as well. To run a modmaster module, just use this syntax on a module:

```bash
modmaster [file]
```

### Configuration
Modmaster has multiple configuration files, which let you control every aspect of its behavior (almost).

# Creating a module
Any executable can be a module. It needs to be able to communicate on port `5382`, or it can use `emit` from the `Client.hs` library.

# Configuration
Here is a small example of a configuration file, currently set to be */etc/modmasterrc*

	modules:/home/joe/Bin/
	registers:/home/joe/Registers/
	rules:/home/joe/rules

The `modules` directory is a place with binary modmaster modules. This can be set to `/usr/bin/` if you would like.

The `registers` directory is where modmaster stores its `registers`. Registers are just shared memory, so that data can be shared module-to-module in `from(a,b) to (c)` blocks in rules.

The `rules` file dictates how the modules work in unison. Here is an example rules file showcasing all of the possible features present:

```
// hworld, espion, echo are all binaries
	when(hworld) emits hworld{ (* Comment *)
	load(espion);
	from(hworld,hworld) to(echo);
	}
```

# License
Copyright (c) 2014, Nate Pisarski

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.

    * Neither the name of Nate Pisarski nor the names of other
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
