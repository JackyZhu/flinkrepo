--********************************************************************--
-- Author:         ljzhu26@hotmail.com
-- Created Time:   2025-09-28 16:33:42
-- Description:    Write your description here
-- Hints:          You can use SET statements to modify the configuration
--********************************************************************--

CREATE TEMPORARY TABLE spotify_streaming_events (
  track_name STRING,
  ts STRING,
  ms_played BIGINT
) WITH (
  'connector' = 'kafka',
  'topic' = 'spotify-streaming-events',
  'properties.bootstrap.servers' = '85.211.178.56:9092',
  'format' = 'json',
  'scan.startup.mode' = 'earliest-offset'
);

CREATE TEMPORARY TABLE popular_tracks( 
track_name  STRING,
play_count  BIGINT
) WITH ( 
'connector' = 'print', 
'logger' = 'true' 
); 

INSERT INTO popular_tracks 
SELECT
  track_name,
  COUNT(*) AS play_count
FROM spotify_streaming_events
GROUP BY track_name
HAVING COUNT(*) > 120;
