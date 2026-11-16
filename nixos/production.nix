{
  assertions = [{
    assertion = false;
    message = "Production NixOS migration is incomplete; migrate and verify storage, secrets, Flux and host services before removing this guard.";
  }];
}
