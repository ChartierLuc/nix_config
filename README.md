This is my nix config.

Currently inspired by [misterio](https://sr.ht/~misterio/nix-config/)

Previously Inspired by [gytis-ivaskevicius](https://github.com/gytis-ivaskevicius/nixfiles) and [Francesco149](https://github.com/Francesco149/flake)


# Usage
```
nixos-rebuild switch --use-remote-sudo --flake .#G7
nixos-rebuild switch --use-remote-sudo --flake .#miBook
nixos-rebuild switch --use-remote-sudo --flake .#frieza
darwin-rebuild switch --flake .#air
```
