{
  dogs = {
    imports = [
      ./configuration.nix
      ./hosts/dogs.nix
      ./vm.nix
    ];
  };

  echoes = {
    imports = [
      ./configuration.nix
      ./hosts/echoes.nix
      ./vm.nix
    ];
  };
}
