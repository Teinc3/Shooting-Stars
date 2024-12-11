classdef AudioManager < handle
    properties (Constant)
        audioFile = 'lib/resources/shooting_stars.mp3';
    end
    properties
        originalSoundtrack % Original audio data
        originalFs         % Original sampling frequency
        player             % audioplayer object
        isPlaying          % Boolean playback state
        volume             % Current volume level (0 to 1)
    end

    methods
        function obj = AudioManager()
            [soundtrack, Fs] = audioread(obj.audioFile);
            obj.originalSoundtrack = soundtrack;
            obj.originalFs = Fs;
            obj.player = audioplayer(soundtrack, Fs);
            obj.player.StopFcn = @(~,~) obj.onPlaybackEnd(); % Set callback for when playback stops
            obj.isPlaying = false;
            obj.setVolume(0.2);
            obj.playSoundtrack();
        end

        function playSoundtrack(obj)
            if obj.isPlaying
                return; % If already playing, do nothing
            end
            play(obj.player);
            obj.isPlaying = true;
        end

        function onPlaybackEnd(obj)
            if obj.isPlaying
                play(obj.player); % Restart playback from the beginning
            end
        end

        function setVolume(obj, volume)
            obj.volume = volume;
            if volume == 0
                if obj.isPlaying
                    stop(obj.player); % Stop playback when volume is 0
                    obj.isPlaying = false;
                end
            else
                % Adjust the audio data based on the volume level
                adjustedSoundtrack = obj.originalSoundtrack * volume;
                % Prevent clipping by ensuring values are within [-1, 1]
                adjustedSoundtrack(adjustedSoundtrack > 1) = 1;
                adjustedSoundtrack(adjustedSoundtrack < -1) = -1;
                
                % Restart playback with the adjusted audio
                if obj.isPlaying
                    stop(obj.player); % Stop current playback
                end
                obj.player = audioplayer(adjustedSoundtrack, obj.originalFs);
                obj.player.StopFcn = @(~,~) obj.onPlaybackEnd(); % Reassign callback
                playSoundtrack(obj);
            end
        end
    end
end