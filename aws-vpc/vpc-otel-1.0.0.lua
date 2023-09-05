function process(tag, timestamp, record)
    -- Extract the log field from the Fluent Bit output
    local log = record["log"]

    -- Split the log by spaces
    local fields = {}
    for word in string.gmatch(log, "%S+") do
        table.insert(fields, word)
    end

    -- Extract fields based on the VPC Flow log format
    local version = fields[1]
    local account_id = fields[2]
    local interface_id = fields[3]
    local srcaddr = fields[4]
    local dstaddr = fields[5]
    local srcport = tonumber(fields[6])
    local dstport = tonumber(fields[7])
    local protocol = tonumber(fields[8])
    local packets = tonumber(fields[9])
    local bytes = tonumber(fields[10])
    local start = tonumber(fields[11])
    local end_time = tonumber(fields[12])
    local action = fields[13]
    local log_status = fields[14]

    -- Map the extracted fields to the provided mappings
    local mapped_log = {
        ["@timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S", start),
        ["observedTimestamp"] = os.date("!%Y-%m-%dT%H:%M:%S", end_time),
        ["body"] = log,
        ["event"] = {
            ["category"] = "network_traffic",
            ["type"] = "connection",
            ["action"] = action,
            ["outcome"] = log_status
        },
        ["communication"] = {
            ["source"] = {
                ["ip"] = srcaddr,
                ["port"] = srcport,
                ["bytes"] = bytes,
                ["packets"] = packets
            },
            ["destination"] = {
                ["ip"] = dstaddr,
                ["port"] = dstport
            }
        }
    }

    -- Return the mapped log
    return 1, timestamp, mapped_log
end