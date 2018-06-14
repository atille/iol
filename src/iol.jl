# https://github.com/atille/iol
# Used as a module for better performances.
module Iol

	# main function, containing the whole application.
	# represented as a kind of singleton.
	function main(args::Array)
	
		# We create local folders containing the tasks
		# if not already available.
		initialize()

		# We verify that CLI arguments are defined, or
		# we die the script.
		er = isassigned(args, 1)
		er = isassigned(args, 2)

		if er == false
			println("An error occured. Exiting.")
			quit()
		end

		action, argument = args

		# Adding a new task.
		if action == "--add" || action == "-a"
			add_task(action, argument)
		end

		# Listing all the tasks available.
		if action == "--list" || action == "-l"
			list_tasks(action, argument)
		end

	end

	function list_tasks(operation::String, argument::String)
		
		if argument == "all"
			map(readdir("tasks/")) do x
				map(readdir("tasks/$x/")) do y
					println(get_task_content("tasks/$x/$y"))
				end
			end
		end

		if argument != "all"
			map(readdir("tasks/$argument/")) do x
				println(x)
			end
		end
	end

	function get_task_content(path::String)
	
		isfile(path) || println("Task $path doesn't exist.")

		f = open(path)

		output_content = ""
		for line in eachline(f)
			t_key, t_value = split(line, "&&:")

			if isequal(t_key, "ID")
				output_content = string(output_content, t_value)
			end

			if isequal(t_key, "DATE")
				output_content = string(output_content, " | ", t_value)
			end

			if isequal(t_key, "CONTENT")
				output_content = string(output_content, " | ", t_value)
			end
		end

		return output_content
	end

	function add_task(operation::String, argument::String)
		
		task_data = parse(argument)
		task_date = get_date(task_data)
		task_status = get_status(task_data)

		save_task(task_data["content"], task_date, task_status)
	end 

	function save_task(content::AbstractString, task_date::DateTime, status::AbstractString)
		
		current_time = now()
		noteid = randstring(4)
		f = open(string("tasks/", status, "/", current_time, ".iolt"), "a+")
		write(f, string("ID&&:", noteid, "\n"))
		write(f, string("DATE&&:", task_date, "\n"))
		write(f, string("STATUS&&:", status, "\n"))
		write(f, string("CONTENT&&:", content, "\n"))

		close(f)
		println(readstring(open("tasks/$status/$current_time.iolt", "r")))
	end

	function get_status(data::Dict)
		try
			return data["status"]
		catch
			status = "pending"
		end
	end


	# define the due_date to tomorrow if nothing has been specified
	# in the args[2] argument. (d=...)
	function get_date(data::Dict)
		today = now()
		try
			if data["due_date"] == "tomorrow"
				defined_due = today + Dates.Day(1)
			end

			if startswith(data["due_date"], "+")
				delay = split(data["due_date"], "+")[2]
				defined_due = today + Dates.Day(delay)
			end

			return defined_due
		catch
			tomorrow = today + Dates.Day(1)
			return tomorrow
		end
	end

	# Function to parse the content submitted as the second argument.
	# eg: iol --add "c=This is a task&d=tommorow&s=pending"
	# c= : task content
	# d= : due date, with shortcuts
	# s= : status
	function parse(task_content::String)
		
		parsed = split(task_content, "&")

		# We are gonna return the list of elements as a pair dictionnary.
		# parsed_values["content"]
		# parsed_values["status"]
		# parsed_values["due_date"]

		parsed_values = Dict()
		for element in parsed
			if startswith(element, "c=")
				parsed_values["content"] = split(element, "c=")[2]

			elseif startswith(element, "s=")
				parsed_values["status"] = split(element, "s=")[2]

			elseif startswith(element, "d=")
				parsed_values["due_date"] = split(element, "d=")[2]

			end
		end

		return parsed_values		
	end

	function initialize()
		dirs = ["tasks", "tasks/open", "tasks/closed", "tasks/pending"]

		map(dirs) do dir
			if isdir(dir) == false
				mkdir(dir)
			end
		end
	end

end

Iol.main(ARGS)
