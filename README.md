#modmaster
Modmaster is a module system for linux written in Haskell. It reads a rules file, which specify which actions to take when a *signal* is emitted from a proram. Signals are strings over port 5382 with the syntax module:signal. One of any module can pick the signal up and respond to it, and even fire their own signals as a result of it.

# Features
### Modal server executable
The Modmaster server is the modmaster client program as well. To run a modmaster module, just use this syntax on a module:
	modmaster [file]
### Whitespace-independant parsing of rules file
Do you have some whacky way of indenting your rules? No problem, modmaster can adapt.
### Highly configurable
Modmaster has multiple configuration files which control nearly every aspect of its behavior. In later versions, every hardcoded aspect of the server will be changable through a configuration file.

# How can I make a module?
Any executable is a module. As long as the binary can communicate on port 5382 correctly (or use the Client.hs library and just call **emit**), it can be a modmaster plugin.

# Configuration
Here is a small example of a configuration file, currently set to be */etc/modmasterrc*

	modules:/home/joe/Bin/
	registers:/home/joe/Registers/
	rules:/home/joe/rules

The modules directory is a place with binary modmaster modules. This can be set to /usr/bin/ if you would like.

The registers directory is where modmaster stores its registers. Registers are logs for variables in modules, so that they can be shared in-between each other in from(a,b) to(c) blocks within the rules.

The rules file dictates how the modules work in unison. Here is an example rules file showcasing all of the possible features present:

	when(hworld) emits hworld{ (* Comment *)
	load(espion);
	from(hworld,hworld) to(echo);
	}

The final semicolon on the last line is optional, as is the "emits" word, all whitespace, newlines, and tabs, and obviously the comment.

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

# TODO
* Make registers WAY easier to use, and less fragile.
* Add better logging measures
* Modify Cookbook to get the cluttery functions out of the code
* Make more platform-independant
