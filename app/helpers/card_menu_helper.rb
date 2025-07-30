module CardMenuHelper
  def ingredients_to_tags(raw)
    return [] if raw.blank?

    raw.split(",").map(&:strip).reject(&:empty?).uniq.map(&:capitalize)
  end
end
