class AddLinkUrl < ActiveRecord::Migration
  def up
  	add_column(:links, :url, :string)
  end

  def down
  end
end
