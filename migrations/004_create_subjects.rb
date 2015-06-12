Sequel.migration do
  up do
    create_table(:subjects) do
      primary_key :id

      String :name

      foreign_key :topic_id
    end
  end

  down do
    drop_table(:subjects)
  end
end