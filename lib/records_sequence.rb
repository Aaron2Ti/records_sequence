# RecordsSequence
module ActiveRecord
  class Base

    def next(*args)
      options = args.extract_options!
      options.update(:current => self)
      self.class.find(:next, options)
    end

    def previous(*args)
      options = args.extract_options!
      options.update(:current => self)
      self.class.find(:previous, options)
    end

    class << self
      def find(*args)
        options = args.extract_options!
        validate_find_options(options)
        set_readonly_option!(options)

        case args.first
        when :first then find_initial(options)
        when :last  then find_last(options)
        when :all   then find_every(options)
        when :next   then find_next(options)
        when :previous   then find_previous(options)
        else             find_from_ids(args, options)
        end
      end

      private
        def find_next(options)
          options[:sorted_by] ||= 'id'
          sorted_by = options[:current].read_attribute(options[:sorted_by])
          if options[:conditions].class == Array
            options[:conditions][0] += " and #{options[:sorted_by]} > ?"
            options[:conditions] << sorted_by
          else
            options.update(:conditions => ["#{options[:sorted_by]} > ?", sorted_by])
          end

          options[:order] = options[:order] ? 
            options[:sorted_by] + ', ' + options[:order] : options[:sorted_by]
          find_initial(options)
        end

        def find_previous(options)
          options[:sorted_by] ||= 'id'
          sorted_by = options[:current].read_attribute(options[:sorted_by])
          if options[:conditions].class == Array
            options[:conditions][0] += " and #{options[:sorted_by]} < ?"
            options[:conditions] << sorted_by
          else
            options.update(:conditions => ["#{options[:sorted_by]} < ?", sorted_by])
          end

          options[:order] = reverse_sql_order(options[:order]) if options[:order]
          options[:order] = options[:order] ? 
            options[:sorted_by] + ', ' + options[:order] : options[:sorted_by]
          find_last(options)
        end

      protected
        VALID_FIND_OPTIONS.push :current, :sorted_by
    end
  end
end
