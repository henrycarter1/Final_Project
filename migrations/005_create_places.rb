Sequel.migration do
  up do
    create_table(:places) do
      primary_key :id

      String :name

      foreign_key :subject_id
    end
  end

  down do
    drop_table(:places)
  end
end