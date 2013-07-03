#!/usr/bin/env ruby -wKU

require 'RMagick'
require 'pp'
include Magick

class BNPbreaker
  COORD = []
  COORD[1] = { xa: 5,   ya: 5,   xb: 27,   yb: 26 }
  COORD[2] = { xa: 32,  ya: 5,   xb: 54,   yb: 26 }
  COORD[3] = { xa: 59,  ya: 5,   xb: 81,   yb: 26 }
  COORD[4] = { xa: 86,  ya: 5,   xb: 108,  yb: 26 }
  COORD[5] = { xa: 113, ya: 5,   xb: 135,  yb: 26 }
  COORD[6] = { xa: 5,   ya: 32,  xb: 27,   yb: 53 }
  COORD[7] = { xa: 32,  ya: 32,  xb: 54,   yb: 53 }
  COORD[8] = { xa: 59,  ya: 32,  xb: 81,   yb: 53 }
  COORD[9] = { xa: 86,  ya: 32,  xb: 108,  yb: 53 }
  COORD[10]= { xa: 113, ya: 32,  xb: 135,  yb: 53 }
  COORD[11]= { xa: 1,   ya: 59,  xb: 27,   yb: 80 }
  COORD[12]= { xa: 32,  ya: 59,  xb: 54,   yb: 80 }
  COORD[13]= { xa: 59,  ya: 59,  xb: 81,   yb: 80 }
  COORD[14]= { xa: 86,  ya: 59,  xb: 105,  yb: 80 }
  COORD[15]= { xa: 113, ya: 59,  xb: 135,  yb: 80 }
  COORD[16]= { xa: 5,   ya: 86,  xb: 27,   yb: 107 }
  COORD[17]= { xa: 32,  ya: 86,  xb: 54,   yb: 107 }
  COORD[18]= { xa: 59,  ya: 86,  xb: 81,   yb: 107 }
  COORD[19]= { xa: 86,  ya: 86,  xb: 108,  yb: 107 }
  COORD[20]= { xa: 113, ya: 86,  xb: 135,  yb: 107 }
  COORD[21]= { xa: 5,   ya: 113, xb: 27,   yb: 134 }
  COORD[22]= { xa: 32,  ya: 113, xb: 54,   yb: 134 }
  COORD[23]= { xa: 59,  ya: 113, xb: 81,   yb: 134 }
  COORD[24]= { xa: 86,  ya: 113, xb: 108,  yb: 134 }
  COORD[25]= { xa: 113, ya: 113, xb: 135,  yb: 134 }

  def decode(image_path)
    img = Image.read(image_path).first
    pixels,blacks = [], []
    img.each_pixel do |pixel, c, r|
      color = pixel.to_color(SVGCompliance,false,8,hex=true)
      if color == '#000000'
        blacks.push({c: c, r: r})
      end
    end
    #drawMatrix(blacks)
    res = []
    res[0] = find_0_position(blacks)
    res[1] = find_1_position(blacks)
    res[2] = find_2_position(blacks)
    res[3] = find_3_position(blacks)
    res[4] = find_4_position(blacks)
    res[5] = find_5_position(blacks)
    res[6] = find_6_position(blacks)
    res[7] = find_7_position(blacks)
    res[8] = find_8_position(blacks)
    res[9] = find_9_position(blacks)

    drawResult(res)

    numbers = []
    res.each_with_index do |cr, index|
      numbers[index] = case_to_click(cr)
    end
    p numbers
    numbers
  end

  def case_to_click(cr)
    COORD.each_with_index do |coord, index|
      if coord && coord[:xa] < cr[:c] && cr[:c] < coord[:xb] &&
                  coord[:ya] < cr[:r] && cr[:r] < coord[:yb]
      return index
      end
    end
  end

  def drawResult(res)
    (0..@maxRow).each do |r|
      row = []
      (0..@maxCol).each do |c|
        if res[0][:r] == r && res[0][:c] == c
          row << 0
        elsif res[1][:r] == r && res[1][:c] == c
          row << 1
        elsif res[2][:r] == r && res[2][:c] == c
          row << 2
        elsif res[3][:r] == r && res[3][:c] == c
          row << 3
        elsif res[4][:r] == r && res[4][:c] == c
          row << 4
        elsif res[5][:r] == r && res[5][:c] == c
          row << 5
        elsif res[6][:r] == r && res[6][:c] == c
          row << 6
        elsif res[7][:r] == r && res[7][:c] == c
          row << 7
        elsif res[8][:r] == r && res[8][:c] == c
          row << 8
        elsif res[9][:r] == r && res[9][:c] == c
          row << 9
        else
          row << '.'
        end
      end
      p r.to_s + "|" + row.join
    end
  end

  def drawMatrix(matrix)
    @maxCol = maxCol(matrix)
    @maxRow = maxRow(matrix)
    res = []
    (0..@maxRow).each do |r|
      row = []
      (0..@maxCol).each do |c|
        if matrix.include?({c: c, r: r})
          row << 0
        else
          row << 1
        end
      end
      res.push row
      p row.join
    end
    res
  end

  def maxCol(matrix)
    max = 0
    matrix.each do |cr|
      if cr[:c]>max
        max = cr[:c]
      end
    end
    max
  end

  def maxRow(matrix)
    max = 0
    matrix.each do |cr|
      if cr[:r]>max
        max = cr[:r]
      end
    end
    max
  end

  def find_1_position(blacks)
    blacks.each do |cr|
      r = cr[:r]
      c = cr[:c]
      if blacks.include?({r: r-1, c: c+1}) &&
        blacks.include?({r: r-1, c: c+2}) &&
        blacks.include?({r: r-1, c: c+3}) &&
        blacks.include?({r: r-2, c: c+3}) &&
        blacks.include?({r: r-3, c: c+3}) &&
        blacks.include?({r: r, c: c+3}) &&
        blacks.include?({r: r+1, c: c+3})
        return cr
      end
    end
  end

  def find_2_position(blacks)
    blacks.each do |cr|
      r = cr[:r]
      c = cr[:c]
      if blacks.include?({r: r, c: c}) &&
        blacks.include?({r: r+1, c: c}) &&
        blacks.include?({r: r, c: c+1}) &&
        blacks.include?({r: r+1, c: c+1}) &&
        blacks.include?({r: r, c: c+2}) &&
        blacks.include?({r: r+1, c: c+2}) &&
        blacks.include?({r: r, c: c+4}) &&
        blacks.include?({r: r+1, c: c+4})
        return cr
      end
    end
  end


  def find_3_position(blacks)
    blacks.each do |cr|
      r = cr[:r]
      c = cr[:c]
      if blacks.include?({r: r, c: c}) &&
        !blacks.include?({ r: r, c: c-1}) &&
        !blacks.include?({ r: r, c: c-2}) &&
        blacks.include?({ r: r-2, c: c+1}) &&
        blacks.include?({ r: r-2, c: c+1}) &&
        blacks.include?({ r: r-1, c: c+1}) &&
        blacks.include?({ r: r+1, c: c+1}) &&
        blacks.include?({ r: r+2, c: c+1}) &&
        true
        return cr
      end
    end
  end


  def find_4_position(blacks)
    blacks.each do |cr|
      r = cr[:r]
      c = cr[:c]
      if blacks.include?({r: r, c: c}) &&
        blacks.include?({ r: r, c: c}) &&
        blacks.include?({ r: r, c: c+1}) &&
        blacks.include?({ r: r, c: c-1}) &&
        blacks.include?({ r: r, c: c-2}) &&
        blacks.include?({ r: r, c: c-3}) &&
        blacks.include?({ r: r, c: c-4}) &&
        blacks.include?({ r: r+1, c: c}) &&
        blacks.include?({ r: r+2, c: c}) &&
        blacks.include?({ r: r-1, c: c}) &&
        blacks.include?({ r: r-2, c: c}) &&
        blacks.include?({ r: r-1, c: c-4}) &&
        true
        return cr
      end
    end
  end

  def find_5_position(blacks)
    blacks.each do |cr|
      r = cr[:r]
      c = cr[:c]
      if blacks.include?({r: r, c: c}) &&
        blacks.include?({ r: r, c: c}) &&
        blacks.include?({ r: r+1, c: c}) &&
        blacks.include?({ r: r, c: c+1}) &&
        blacks.include?({ r: r, c: c+2}) &&
        blacks.include?({ r: r, c: c+3}) &&
        blacks.include?({ r: r-3, c: c+1}) &&
        blacks.include?({ r: r-3, c: c+2}) &&
        blacks.include?({ r: r-3, c: c+3}) &&
        blacks.include?({ r: r+4, c: c}) &&
        true
        return cr
      end
    end
  end

  def find_6_position(blacks)
    blacks.each do |cr|
      r = cr[:r]
      c = cr[:c]
      if blacks.include?({r: r, c: c}) &&
        blacks.include?({ r: r+1, c: c}) &&
        blacks.include?({ r: r+2, c: c}) &&
        blacks.include?({ r: r-1, c: c}) &&
        blacks.include?({ r: r-2, c: c}) &&
        blacks.include?({ r: r-3, c: c+4}) &&
        blacks.include?({ r: r+3, c: c+4}) &&
        blacks.include?({ r: r, c: c}) &&
        true
        return cr
      end
    end
  end

  def find_7_position(blacks)
    blacks.each do |cr|
      r = cr[:r]
      c = cr[:c]
      if blacks.include?({r: r, c: c}) &&
        blacks.include?({ r: r, c: c-1}) &&
        blacks.include?({ r: r, c: c+1}) &&
        blacks.include?({ r: r, c: c+2}) &&
        blacks.include?({ r: r, c: c+3}) &&
        blacks.include?({ r: r+7, c: c}) &&
        blacks.include?({ r: r+8, c: c}) &&
        true
        return cr
      end
    end
  end

  def find_8_position(blacks)
    blacks.each do |cr|
      r = cr[:r]
      c = cr[:c]
      if blacks.include?({r: r, c: c}) &&
        blacks.include?({ r: r, c: c}) &&
        blacks.include?({ r: r, c: c-1}) &&
        blacks.include?({ r: r, c: c+1}) &&
        blacks.include?({ r: r-4, c: c}) &&
        blacks.include?({ r: r+5, c: c-1}) &&
        blacks.include?({ r: r+5, c: c+1}) &&
        blacks.include?({ r: r+3, c: c-2}) &&
        blacks.include?({ r: r+3, c: c+2}) &&
        true
        return cr
      end
    end
  end

  def find_9_position(blacks)
    blacks.each do |cr|
      r = cr[:r]
      c = cr[:c]
      if blacks.include?({r: r, c: c}) &&
        blacks.include?({ r: r, c: c}) &&
        blacks.include?({ r: r, c: c+1}) &&
        blacks.include?({ r: r, c: c+2}) &&
        blacks.include?({ r: r+3, c: c}) &&
        blacks.include?({ r: r+3, c: c-1}) &&
        blacks.include?({ r: r+4, c: c+1}) &&
        blacks.include?({ r: r+4, c: c+2}) &&
        true
        return cr
      end
    end
  end

  def find_0_position(blacks)
    blacks.each do |cr|
      r = cr[:r]
      c = cr[:c]
      if blacks.include?({ r: r, c: c}) &&
        blacks.include?({ r: r-1, c: c}) &&
        blacks.include?({ r: r+1, c: c}) &&
        blacks.include?({ r: r-1, c: c+4}) &&
        blacks.include?({ r: r+1, c: c+4}) &&
        blacks.include?({ r: r-4, c: c+2}) &&
        true
        return cr
      end
    end
  end
end

