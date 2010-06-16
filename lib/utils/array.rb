class Array
  def sum
    inject( nil ) { |sum,x| sum ? sum+x : x }
  end
  
  def sjoin( fmt, sep )
      collect { |x| Kernel::sprintf( fmt, x ) }.join( sep )
  end
end