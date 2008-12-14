#!/usr/bin/env ruby

require 'diff/lcs'
require 'rexml/document'
require 'delegate'

def Math.max(a, b)
	a > b ? a : b
end

module REXML

	class Text 
		def deep_clone
			clone
		end
	end

	class HashableElementDelegator < DelegateClass(Element)
		def initialize(sub)
			super sub
		end
		def == other
			res = other.to_s.strip == self.to_s.strip
			res
		end

		def eql? other
			self == other
		end

		def[](k)
			r = super
			if r.kind_of? __getobj__.class
				self.class.new(r)
			else
				r
			end
		end

		def hash
			r = __getobj__.to_s.hash
			r
		end
	end

end

class XHTMLDiff
	include REXML
  attr_accessor :output

	class << self
		BLOCK_CONTAINERS = ['div', 'ul', 'li']
		def diff(a, b)
			if a == b
				return a.deep_clone
			end
			if REXML::HashableElementDelegator === a and REXML::HashableElementDelegator === b
				o = REXML::Element.new(a.name)
				o.add_attributes  a.attributes
				hd = self.new(o)
				Diff::LCS.traverse_balanced(a, b, hd)
				o
			elsif REXML::Text === a and REXML::Text === b
				o = REXML::Element.new('span')
				aa = a.value.split(/\s/)
				ba = b.value.split(/\s/)
				hd = XHTMLTextDiff.new(o)
				Diff::LCS.traverse_balanced(aa, ba, hd)
				o
			else
				raise ArgumentError.new("both arguments must be equal or both be elements. a is #{a.class.name} and b is #{b.class.name}")
			end
		end
	end

	def diff(a, b)
		self.class.diff(a,b)
	end

  def initialize(output)
    @output = output
  end

    # This will be called with both elements are the same
  def match(event)
    @output << event.old_element.deep_clone if event.old_element
  end

  # This will be called when there is an element in A that isn't in B
  def discard_a(event)
		@output << wrap(event.old_element, 'del') 
  end
  
	def change(event)
		begin
			sd = diff(event.old_element, event.new_element)
		rescue ArgumentError
			sd = nil
		end
		if sd and (ratio = (Float(rs = sd.to_s.gsub(%r{<(ins|del)>.*</\1>}, '').size) / bs = Math.max(event.old_element.to_s.size, event.new_element.to_s.size))) > 0.5
			@output << sd
		else
			@output << wrap(event.old_element, 'del')
			@output << wrap(event.new_element, 'ins')
		end
  end

  # This will be called when there is an element in B that isn't in A
  def discard_b(event)
		@output << wrap(event.new_element, 'ins')
	end

	def choose_event(event, element, tag)
  end

	def wrap(element, tag = nil)
		if tag 
			el = Element.new tag
			el << element.deep_clone
		else
			el = element.deep_clone
		end
		el
	end

	class XHTMLTextDiff < XHTMLDiff
		def change(event)
			@output << wrap(event.old_element, 'del')
			@output << wrap(event.new_element, 'ins')
		end

		# This will be called with both elements are the same
		def match(event)
			@output << wrap(event.old_element, nil) if event.old_element
		end

		# This will be called when there is an element in A that isn't in B
		def discard_a(event)
			@output << wrap(event.old_element, 'del') 
		end
		
		# This will be called when there is an element in B that isn't in A
		def discard_b(event)
			@output << wrap(event.new_element, 'ins')
		end

		def wrap(element, tag)
			element = REXML::Text.new(" " << element) if String === element
			super element, tag
		end
	end
		
end

if $0 == __FILE__

	$stderr.puts "No tests available yet"
	exit(1)

end
