function process(tag, timestamp, record)
    local log = record["Records"][1]  -- Extract the first record from the "Records" array

    if not log then
        return 0 -- skip this record if decoding fails
    end

    local transformed_log = {}

    -- Mapping for '@timestamp'
    transformed_log["@timestamp"] = log["eventTime"] or ""

    -- Mapping for 'event'
    transformed_log["event"] = {
        domain = "cloudtrail",
        name = log["eventName"] or "",
        source = log["eventSource"] or "",
        category = log["eventCategory"] or "",
        type = log["eventType"] or "",
        kind = log["managementEvent"] and "Management" or "Data",
        result = log["readOnly"] and "Read" or "Write"
    }

    -- Mapping for 'attributes'
    transformed_log["attributes"] = {
        data_stream = {
            dataset = "aws_cloudtrail",
            namespace = "observability",
            type = "logs"
        }
    }

    -- Mapping for 'cloud' based on the provided mapping
    transformed_log["cloud"] = {
        provider = "aws",
        account = {
            id = log["recipientAccountId"] or ""
        },
        region = log["awsRegion"] or "",
        resource_id = "",  -- This field is not present in the sample log. You might need to adjust this based on your actual logs.
        availability_zone = "",  -- This field is also not present in the sample log. Adjust as needed.
        platform = ""  -- This field is not present in the sample log. Adjust as needed.
    }

    -- Mapping for 'aws'
    transformed_log["aws"] = {
        cloudtrail = log  -- Directly embed the entire cloudtrail log
    }

    -- Mapping for 'body'
   transformed_log["body"] = record["log"] or ""  -- Use the original log entry

    -- Check if the transformed log is empty
    if next(transformed_log) == nil then
        return 0 -- skip this record
    end

    return 1, timestamp, transformed_log
end