segment_start = 0
segment_start_str = 0
segment_end_str = 0
segment_length_str = 0

function convert_time_to_string(time)
    --converts time given by mpv into a 'HH:MM:SS.mmm' formatted string
    local minutes = time / 60
    local remainder = time % 60
    local hours = minutes / 60
    local minutes = minutes % 60
    local seconds = math.floor(remainder)
    local milliseconds = math.floor((remainder - seconds) * 1000)
    local result_string = string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
    return result_string
end

function start()
    segment_start = mp.get_property_number("time-pos")
    segment_start_str = convert_time_to_string(segment_start)
    mp.observe_property("time-pos", "number", get_length)
end

function get_length()
    local segment_end = mp.get_property_number("time-pos")
    segment_end_str = convert_time_to_string(segment_end)

    local segment_length_length = segment_end - segment_start
    if segment_length_length < 0 then
        segment_length_length = 0
    end
    segment_length_str = convert_time_to_string(segment_length_length)
    show_result()
end

function stop()
    mp.unobserve_property(get_length)
    mp.osd_message("")
end

function show_result()
    message = string.format("Segment start: %s", segment_start_str) .. "\n" ..
    string.format("Segment end: %s", segment_end_str) .. "\n" .. 
    string.format("Length: %s", segment_length_str)
    mp.osd_message(message, 60)
end

mp.add_key_binding("Ctrl+z", "start", start)
mp.add_key_binding("Ctrl+x", "stop", stop)
