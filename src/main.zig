const std = @import("std");

const wasm4_module = @import("wasm4.zig");
const graphics_util_module = @import("graphics_util.zig");
const point_arrays_module = @import("point_arrays.zig");
const gamestate_module = @import("gamestate.zig");
const palettes_module = @import("palettes.zig");
const timer_module = @import("timer.zig");
const audio_util_module = @import("audio_util.zig");
const game_ui_module = @import("game_ui.zig");
const geometry_module = @import("zignal/geometry.zig");
const math_util_module = @import("math_util.zig");
const datastructs_module = @import("datastructs.zig");

var currentMatchPhase: gamestate_module.MatchPhase = .{ .currentPhase = gamestate_module.MatchPhaseEnum.Paused };

var gameStartTime: timer_module.TimeTracker = .{
    .frameCount = gameStartTimeDefault.frameCount,
    .seconds = gameStartTimeDefault.seconds,
    .minutes = gameStartTimeDefault.minutes,
    .hours = gameStartTimeDefault.hours,
};

pub const gameStartTimeDefault : timer_module.TimeTracker = .{
    .frameCount = 0,
    .seconds = 4,
    .minutes = 0,
    .hours = 0,
};

var fixedAudioBuffer: datastructs_module.FixedArrayRingBuffer(audio_util_module.Sound) = undefined;

var trackAudioQueueTime: timer_module.TimeTracker = .{
    .frameCount = 0,
    .seconds = 0,
    .minutes = 0,
    .hours = 0,
};

var fixedAudioBuffer2: datastructs_module.FixedArrayRingBuffer(audio_util_module.Sound) = undefined;

var gameStartTrackAudioQueueTime: timer_module.TimeTracker = .{
    .frameCount = gameStartTrackAudioQueueTimeDefault.frameCount,
    .seconds = 0,
    .minutes = 0,
    .hours = 0,
};

pub const gameStartTrackAudioQueueTimeDefault : timer_module.TimeTracker = .{
    .frameCount = 59,
    .seconds = 0,
    .minutes = 0,
    .hours = 0,
};

var gameStartAudioQueue: audio_util_module.AudioRingBuffer = undefined;

var victoryAudioQueue: audio_util_module.AudioRingBuffer = undefined;

var trackTimePassed: timer_module.TimeTracker = .{
    .frameCount = 0,
    .seconds = 0,
    .minutes = 0,
    .hours = 0,
};

var trackTimeCountdown: timer_module.TimeTracker = .{
    .frameCount = 0,
    .seconds = 0,
    .minutes = 0,
    .hours = 0,
};

var prevInputState: u8 = 0;

var totalFrameCount: u32 = 0;
var frameCount: u32 = 0;

var prng: std.Random.DefaultPrng = undefined;
var randomNumberGenerator: std.Random = undefined;

pub fn resetGame() void {
    
}

pub fn startAudioQueues() void {
    const audioBuffer: [64]audio_util_module.Sound = undefined;

    fixedAudioBuffer = .{
            .arrayT = audioBuffer,
            .usedLen = 0,
            .readIndex = 0,
            .writeIndex = 0,
    };

    const audioBuffer2: [64]audio_util_module.Sound = undefined;

    fixedAudioBuffer2 = .{
            .arrayT = audioBuffer2,
            .usedLen = 0,
            .readIndex = 0,
            .writeIndex = 0,
    };

    gameStartAudioQueue = .{
        .ringBuffer = fixedAudioBuffer2,
        .readingActive = false,
        .soundsAdded = 0,
        .soundsPlayed = 0,
        .timeTillRead = gameStartTrackAudioQueueTime,
        .timeBetweenReads = gameStartTrackAudioQueueTimeDefault,
    };

    victoryAudioQueue = .{
        .ringBuffer = fixedAudioBuffer,
        .readingActive = false,
        .soundsAdded = 0,
        .soundsPlayed = 0,
        .timeTillRead = trackAudioQueueTime,
        .timeBetweenReads = audio_util_module.musicTrackAudioQueueTimeDefault,
    };
}

pub fn startTimers() void {
    timer_module.setTimeValuesMinutes(
        &trackAudioQueueTime,
        audio_util_module.musicTrackAudioQueueTimeDefault.frameCount,
        audio_util_module.musicTrackAudioQueueTimeDefault.seconds, 
        audio_util_module.musicTrackAudioQueueTimeDefault.minutes
    );

    timer_module.setTimeValuesSeconds(
        &gameStartTrackAudioQueueTime,
        gameStartTrackAudioQueueTimeDefault.frameCount,
        gameStartTrackAudioQueueTimeDefault.seconds
    );
}

export fn start() void {
    wasm4_module.PALETTE.* = palettes_module.spacehaze;

    var split: std.Random.SplitMix64 = std.Random.SplitMix64.init(@intFromPtr(wasm4_module.TIMESTAMP));
    prng = std.Random.DefaultPrng.init(split.next());
    randomNumberGenerator = prng.random();

    // Randomly generate X numbers to skip similar outputs before X
    const randomNumbers: u8 = 80;
    var randomCount: u8 = 0;
    while (randomCount < randomNumbers) : (randomCount += 1) {
        _ = randomNumberGenerator.int(u8);
    }

    prevInputState = wasm4_module.GAMEPAD1.*;

    startAudioQueues();
    startTimers();

    currentMatchPhase.currentPhase = gamestate_module.MatchPhaseEnum.Starting;
}

export fn update() void {

    totalFrameCount = totalFrameCount + 1;
    frameCount = frameCount + 1;

    // Input
    const activeButtonsThisFrame = wasm4_module.GAMEPAD1.* & (wasm4_module.GAMEPAD1.* ^ prevInputState);

    if (activeButtonsThisFrame & wasm4_module.BUTTON_UP != 0) {
        
    }

    if (activeButtonsThisFrame & wasm4_module.BUTTON_DOWN != 0) {

    }

    if (activeButtonsThisFrame & wasm4_module.BUTTON_LEFT != 0) {

    }

    if (activeButtonsThisFrame & wasm4_module.BUTTON_RIGHT != 0) {

    }

    if (activeButtonsThisFrame & wasm4_module.BUTTON_1 != 0) {

    }

    if (activeButtonsThisFrame & wasm4_module.BUTTON_2 != 0) {

    }

    prevInputState = wasm4_module.GAMEPAD1.*;

    // Trigger audio queues every loop
    if (audio_util_module.tryPlaySoundAudioRingBuffer(&gameStartAudioQueue)) {

    }
    if (audio_util_module.tryPlaySoundAudioRingBuffer(&victoryAudioQueue)) {
        
    }

    // Logic
    if (currentMatchPhase.currentPhase == gamestate_module.MatchPhaseEnum.Starting) {
        timer_module.trackTimeDecreasing(&gameStartTime);

        if (gameStartTime.frameCount == 0 and gameStartTime.seconds == 0) {
            currentMatchPhase.currentPhase = gamestate_module.MatchPhaseEnum.Active;

            gameStartTime = gameStartTimeDefault;
        }
    }

    if (currentMatchPhase.currentPhase == gamestate_module.MatchPhaseEnum.Active) {
        timer_module.trackTimeIncreasing(&trackTimePassed);
        
        timer_module.trackTimeDecreasing(&trackTimeCountdown);
    }

    if (currentMatchPhase.currentPhase == gamestate_module.MatchPhaseEnum.Active) {
        
    }

    if (frameCount % 8 == 0) {

        if (currentMatchPhase.currentPhase == gamestate_module.MatchPhaseEnum.Active) {

        }

        frameCount = 0;
    }

    // Render
    graphics_util_module.fill_c4();
    wasm4_module.DRAW_COLORS.* = 0x0001;

    if (currentMatchPhase.currentPhase == gamestate_module.MatchPhaseEnum.Starting) {

    }

    if (currentMatchPhase.currentPhase == gamestate_module.MatchPhaseEnum.Active) {

    }

    if (currentMatchPhase.currentPhase == gamestate_module.MatchPhaseEnum.Paused) {
        // Draw options menu
        
    }

    if (currentMatchPhase.currentPhase == gamestate_module.MatchPhaseEnum.Victory) {
        
    }

    if (currentMatchPhase.currentPhase == gamestate_module.MatchPhaseEnum.Defeat) {
       
    }
}