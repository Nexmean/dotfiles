export PATH="/opt/homebrew/opt/llvm@12/bin:$PATH"
export PATH="/opt/homebrew/opt/openssl@1.1/lib:$PATH"
export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:/Users/al.makarov/.local/share/neovim/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/Library/Application\ Support/Coursier/bin

export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/llvm@12/lib/ -Wl,-rpath,/opt/homebrew/opt/llvm@12/lib/ -L/opt/homebrew/opt/libpq/lib"

export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/llvm@12/include"

export CPATH=$CPATH:/opt/homebrew/include

export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/lib
export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/opt/libpq/lib

export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

[ -f "/Users/al.makarov/.ghcup/env" ] && source "/Users/al.makarov/.ghcup/env" # ghcup-env

source "$HOME/.cargo/env"

source "$HOME/.nix-profile/etc/profile.d/nix.sh"
