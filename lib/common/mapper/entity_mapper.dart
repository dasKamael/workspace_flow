/// Maps between a persistence `Entity` (drift row) and a domain `Model`.
abstract class EntityMapper<Model, Entity> {
  Model toModel(Entity entity);

  Entity toEntity(Model model);
}
