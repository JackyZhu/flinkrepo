--********************************************************************--
-- Author:         ljzhu26@hotmail.com
-- Created Time:   2025-09-28 19:33:35
-- Description:    Write your description here
-- Hints:          You can use SET statements to modify the configuration
--********************************************************************--

CREATE TEMPORARY TABLE spotify_streaming_events (
  track_name STRING,
  ts STRING,
  ms_played BIGINT,
  fts AS CAST(ts AS TIMESTAMP(0))
) WITH (
  'connector' = 'kafka',
  'topic' = 'spotify-streaming-events',
  'properties.bootstrap.servers' = '85.211.178.56:9092',
  'format' = 'json',
  'scan.startup.mode' = 'earliest-offset'
);


CREATE TEMPORARY TABLE most_played_track_daily_engagement(
play_date STRING,
daily_play_count BIGINT,
daily_play_duration_minutes BIGINT
)
WITH ( 
'connector' = 'print', 
'logger' = 'true' 
); 



INSERT INTO most_played_track_daily_engagement
SELECT
  DATE_FORMAT(fts, 'yyyy-MM-dd') AS play_date,
  COUNT(*) AS daily_play_count,
  SUM(ms_played) / 60000 AS daily_play_duration_minutes
FROM spotify_streaming_events
WHERE track_name = 'Ode To The Mets'
GROUP BY DATE_FORMAT(fts, 'yyyy-MM-dd');
