function process(tag, timestamp, record)
    -- Splitting the log by tabs to extract the fields
    local fields = {}
    for field in string.gmatch(record["log"], "([^\t]+)") do
        table.insert(fields, field)
    end

    -- Extracting fields from the split log
    local date = fields[1]
    local time = fields[2]
    local edgeLocation = fields[3]
    local scBytes = fields[4]
    local cIp = fields[5]
    local csMethod = fields[6]
    local csHost = fields[7]
    local csUriStem = fields[8]
    local scStatus = fields[9]
    local csReferer = fields[10]
    local csUserAgent = fields[11]
    local csUriQuery = fields[12]
    local csCookie = fields[13]
    local xEdgeResultType = fields[14]
    local xEdgeRequestId = fields[15]
    local xHostHeader = fields[16]
    local csProtocol = fields[17]
    local csBytes = fields[18]
    local timeTaken = fields[19]
    local xForwardedFor = fields[20]
    local sslProtocol = fields[21]
    local sslCipher = fields[22]
    local xEdgeResponseResultType = fields[23]
    local csProtocolVersion = fields[24]

    -- Mapping the extracted fields to the OpenTelemetry schema and additional mappings
    record["@timestamp"] = date .. "T" .. time .. "Z"
    record["body"] = record["log"]
    record["@message"] = record["log"]
    record["attributes"] = {}
    record["attributes"]["data_stream"] = {}
    record["attributes"]["data_stream"]["dataset"] = "cloudfront"
    record["attributes"]["data_stream"]["namespace"] = "aws"
    record["attributes"]["data_stream"]["type"] = "log"
    record["event"] = {}
    record["event"]["domain"] = "aws"
    record["event"]["source"] = "cloudfront"
    record["event"]["category"] = "web"
    record["event"]["type"] = csMethod
    record["event"]["kind"] = xEdgeResultType
    record["event"]["result"] = scStatus

    -- Additional mappings
    record["aws"] = {}
    record["aws"]["cloudfront"] = {}
    record["aws"]["cloudfront"]["c-ip"] = cIp
    record["aws"]["cloudfront"]["cs-host"] = csHost
    record["aws"]["cloudfront"]["cs-referer"] = csReferer
    record["aws"]["cloudfront"]["cs-user-agent"] = csUserAgent
    record["aws"]["cloudfront"]["cs-bytes"] = tonumber(csBytes)
    record["aws"]["cloudfront"]["cs-method"] = csMethod
    record["aws"]["cloudfront"]["cs-protocol"] = csProtocol
    record["aws"]["cloudfront"]["cs-protocol-version"] = csProtocolVersion
    record["aws"]["cloudfront"]["cs-uri-query"] = csUriQuery
    record["aws"]["cloudfront"]["cs-uri-stem"] = csUriStem
    record["aws"]["cloudfront"]["cs-cookie"] = csCookie
    record["aws"]["cloudfront"]["sc-bytes"] = tonumber(scBytes)
    record["aws"]["cloudfront"]["sc-status"] = scStatus
    record["aws"]["cloudfront"]["ssl-cipher"] = sslCipher
    record["aws"]["cloudfront"]["ssl-protocol"] = sslProtocol
    record["aws"]["cloudfront"]["time-taken"] = tonumber(timeTaken)
    record["aws"]["cloudfront"]["x-edge-location"] = edgeLocation
    record["aws"]["cloudfront"]["x-edge-request-id"] = xEdgeRequestId
    record["aws"]["cloudfront"]["x-edge-result-type"] = xEdgeResultType
    record["aws"]["cloudfront"]["x-edge-response-result-type"] = xEdgeResponseResultType
    record["aws"]["cloudfront"]["x-forwarded-for"] = xForwardedFor
    record["aws"]["cloudfront"]["x-host-header"] = xHostHeader

    -- Removing the original log field to avoid redundancy
    record["log"] = nil

    return 1, timestamp, record
end