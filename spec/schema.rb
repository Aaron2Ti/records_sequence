ActiveRecord::Schema.define(:version => 1) do
  create_table :users do |t|
    t.string :name, :address, :company 
    t.integer :age
    t.boolean :married, :default => false
  end
end
