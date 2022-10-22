require "curses"

# parse emails.csv and for each row, ask the user if they want to
# add the email to the list -- refreshing the screen each time with curses

@index = 0

def parse_emails_with_curses
  File.open("emails.csv", "r") do |file|
    # skip the first line because CSV headers
    file.gets
    file.each_line do |line|
      @index += 1
      display(line.strip) # strip the newline because curses freaks out otherwise
      input = Curses.getch
      case input
      when "y"
        keep_email(line)
      when "q"
        break
      else
        skip_email(line)
      end
    end
  end
end

def display(line)
  Curses.clear
  Curses.setpos(0, 0)
  Curses.addstr("#{line} - (y/n/q) [#{@index}]")
  Curses.refresh
end

def put_email(email, file)
  File.open(file, "a") do |f|
    f.puts email
  end
end

def keep_email(email)
  put_email(email, "exported.csv")
end

def skip_email(email)
  put_email(email, "skipped.csv")
end

Curses.init_screen
Curses.cbreak
Curses.noecho

parse_emails_with_curses

# close curses
Curses.close_screen
