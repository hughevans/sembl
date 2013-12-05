class ThingImporter
  FIELD_MAPPING = {
    'Row ID' => :import_row_id,
    'Filename' => :image_filename,
    'Image URL' => :image_url,
    'Attribution' => :attribution,
    'URL for context' => :item_url,
    'Alt tag' => :description,
    'Access via' => :access_via,
    'Copyright info' => :copyright
  }.freeze

  def initialize(filename, options={})
    default_options = {
      image_path: File.dirname(filename),
      remote: true
    }

    @filename = filename
    @options = options.reverse_merge(default_options)
  end

  def import
    # Map csv field names to thing attributes
    # Anything unmapped goes into :general_attributes
    csv_processor = ProcessCSV.new(@filename, FIELD_MAPPING, remote: @options[:remote])

    # TODO: remove this once we have import_row_id's and only update/add new
    Thing.delete_all

    csv_processor.foreach do |row|
      begin
        create_thing_from_row(row)
      rescue
        puts "Error loading file #{row[:image_filename]}: #{$!.message}"
      end
    end
  end

private

  def create_thing_from_row(row)
    image_filename = row.delete(:image_filename)
    image_url = row.delete(:image_url)

    # Ignore row if there is no image
    return unless image_filename.present? || image_url.present?

    thing = Thing.new
    image_path = image_url || File.join(@options[:image_path], image_filename)

    if @options[:remote] || image_url.present?
      thing.remote_image_url = image_path
    else
      thing.image = File.open(image_path)
    end

    thing.update(row)
    thing.save!
  end
end