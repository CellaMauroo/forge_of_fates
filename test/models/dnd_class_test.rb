require "test_helper"

class DndClassTest < ActiveSupport::TestCase
  test "full and pact casters gain spellcasting at first level" do
    %w[full pact].each do |spellcasting_type|
      dnd_class = DndClass.new(spellcasting_type: spellcasting_type)

      assert dnd_class.spellcasting_available_at?(1)
    end
  end

  test "half casters gain spellcasting at second level" do
    dnd_class = DndClass.new(spellcasting_type: "half")

    assert_not dnd_class.spellcasting_available_at?(1)
    assert dnd_class.spellcasting_available_at?(2)
  end

  test "noncasters do not gain spellcasting" do
    dnd_class = DndClass.new(spellcasting_type: "none")

    assert_not dnd_class.spellcasting_available_at?(20)
  end
end
