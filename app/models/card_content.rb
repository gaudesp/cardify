class CardContent < Card
  has_rich_text :content

  def to_partial_path
    "cards/card_content"
  end
end
