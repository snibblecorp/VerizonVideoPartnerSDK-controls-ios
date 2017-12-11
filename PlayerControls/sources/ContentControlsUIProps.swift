//  Copyright © 2016 One by Aol : Publishers. All rights reserved.

import Foundation

extension DefaultControlsViewController {
    struct UIProps {
        var loading: Bool
        var controlsViewHidden: Bool
        
        var playButtonHidden: Bool
        var playButtonCommand: Command
        
        var pauseButtonHidden: Bool
        var pauseButtonCommand: Command
        
        var replayButtonHidden: Bool
        var replayButtonCommand: Command
        
        var nextButtonHidden: Bool
        var nextButtonCommand: Command
        var nextButtonEnabled: Bool
        
        var prevButtonHidden: Bool
        var prevButtonCommand: Command
        var prevButtonEnabled: Bool
        
        var seekerViewHidden: Bool
        var seekerViewCurrentTimeText: String
        var seekerViewCurrentTime: UInt
        var seekerViewProgress: CGFloat
        var seekerViewBuffered: CGFloat
        var startSeekCommand: CommandWith<Double>
        var updateSeekCommand: CommandWith<Double>
        var stopSeekCommand: CommandWith<Double>
        var seekToSecondsCommand: CommandWith<UInt>
        var seekBackButtonHidden: Bool
        var seekForwardButtonHidden: Bool
        var seekbarPositionedAtBottom: Bool
        
        var sideBarViewHidden: Bool
        
        var compasBodyViewHidden: Bool
        var compasDirectionViewHidden: Bool
        var compasDirectionViewTransform: CGAffineTransform
        var updateCameraAngles: CommandWith<CGPoint>
        var resetCameraAngles: Command
        var cameraPanGestureIsEnabled: Bool
        var compassViewBelowLive: Bool
        
        var videoTitleLabelHidden: Bool
        var videoTitleLabelText: String
        
        var durationTextHidden: Bool
        var durationTextLabelText: String
        
        var subtitlesTextLabelHidden: Bool
        var subtitlesTextLabelText: String
        
        var thumbnailImageViewHidden: Bool
        var thumbnailImageUrl: URL?
        
        var errorLabelHidden: Bool
        var errorLabelText: String
        var retryButtonHidden: Bool
        var retryButtonCommand: Command
        
        var pipButtonHidden: Bool
        var pipButtonEnabled: Bool
        var pipButtonCommand: Command
        
        var settingsButtonHidden: Bool
        var settingsButtonEnabled: Bool
        var settingsButtonCommand: Command
        
        var airplayActiveLabelHidden: Bool
        var airplayButtonHidden: Bool
        
        var liveIndicationViewIsHidden: Bool
        var liveDotColor: UIColor?
        
        //swiftlint:disable function_body_length
        //swiftlint:disable cyclomatic_complexity
        init(props: Props, controlsViewVisible: Bool) {
            controlsViewHidden = {
                let isPlayerAbsent = props.player == nil
                let isControlsViewHidden = !controlsViewVisible
                let isAirPlayInactive = !(props.player?.item.playable?.airplay.isActive ?? false)
                
                return isPlayerAbsent || (isControlsViewHidden && isAirPlayInactive)
            }()
            
            loading = props.player?.item.playable?.loading ?? false
            
            playButtonHidden = props.player?.item.playable?.playbackCommand.play == nil
            
            playButtonCommand = props.player?.item.playable?.playbackCommand.play ?? .nop
            
            pauseButtonHidden = props.player?.item.playable?.playbackCommand.pause == nil
            
            pauseButtonCommand = props.player?.item.playable?.playbackCommand.pause ?? .nop
            
            replayButtonHidden = props.player?.item.playable?.playbackCommand.replay == nil
            
            replayButtonCommand = props.player?.item.playable?.playbackCommand.replay ?? .nop
            
            nextButtonEnabled = props.player?.playlist?.next != nil
            
            nextButtonCommand = props.player?.playlist?.next ?? .nop
            
            prevButtonEnabled = props.player?.playlist?.prev != nil
            
            prevButtonCommand = props.player?.playlist?.prev ?? .nop
            
            let nextButtonDisabled = !nextButtonEnabled
            let prevButtonDisabled = !prevButtonEnabled
            
            prevButtonHidden = nextButtonDisabled && prevButtonDisabled
            
            nextButtonHidden = nextButtonDisabled && prevButtonDisabled
            
            seekerViewHidden = props.player?.item.playable?.seekbar == nil
            
            durationTextHidden = props.player?.item.playable?.seekbar == nil
            
            durationTextLabelText = {
                guard let seekbar = props.player?.item.playable?.seekbar else { return "" }
                return TimeFormatter.string(from: seekbar.duration)
            }()
            
            seekBackButtonHidden = props.player?.item.playable?.seekbar?.seeker.seekTo == nil
            
            seekForwardButtonHidden = props.player?.item.playable?.seekbar?.seeker.seekTo == nil
            
            seekToSecondsCommand = props.player?.item.playable?.seekbar?.seeker.seekTo ?? .nop
            
            startSeekCommand = props.player?.item.playable?.seekbar?.seeker.state.start ?? .nop
            
            updateSeekCommand = props.player?.item.playable?.seekbar?.seeker.state.update ?? .nop
            
            stopSeekCommand = props.player?.item.playable?.seekbar?.seeker.state.stop ?? .nop
            
            seekerViewCurrentTimeText = {
                guard let seekbar = props.player?.item.playable?.seekbar else { return "" }
                return TimeFormatter.string(from: seekbar.currentTime)
            }()
            
            seekerViewCurrentTime = props.player?.item.playable?.seekbar?.currentTime ?? 0
            
            seekerViewProgress = CGFloat(props.player?.item.playable?.seekbar?.progress ?? 0)
            
            seekerViewBuffered = CGFloat(props.player?.item.playable?.seekbar?.buffered ?? 0)
            
            seekbarPositionedAtBottom = {
                guard let playable = props.player?.item.playable else { return false }
                let hasNoTitle = playable.title.characters.count == 0
                let hasNoSettings = playable.settings.isHidden
                let hasNoPipButton = playable.pictureInPictureControl.isUnsupported
                let hasNoAirplayButton = playable.airplay.isHidden
                return hasNoTitle && hasNoSettings && hasNoPipButton && hasNoAirplayButton
            }()
            
            sideBarViewHidden = props.player?.item.playable?.sideBarViewHidden ?? true
            
            compasBodyViewHidden = props.player?.item.playable?.camera == nil
            
            compasDirectionViewHidden = props.player?.item.playable?.camera == nil
            
            compasDirectionViewTransform = {
                guard let camera = props.player?.item.playable?.camera else { return CGAffineTransform.identity }
                return CGAffineTransform(rotationAngle: .init(-camera.angles.horizontal))
            }()
            
            updateCameraAngles = {
                guard let camera = props.player?.item.playable?.camera else { return .nop }
                return camera.moveTo.map { translation in
                    var angles = camera.angles
                    angles.horizontal += Float(translation.x) * 0.01
                    angles.vertical += Float(translation.y) * 0.01
                    return angles
                }
            }()
            
            resetCameraAngles = {
                guard let camera = props.player?.item.playable?.camera else { return .nop }
                return camera.moveTo.bind(to: .init())
            }()
            
            cameraPanGestureIsEnabled = props.player?.item.playable?.camera != nil
            
            videoTitleLabelHidden = props.player?.item.playable == nil
            
            videoTitleLabelText = props.player?.item.playable?.title ?? ""
            
            subtitlesTextLabelText = {
                guard let state = props.player?.item.playable?.legible.external?.external.available  else { return "" }
                switch state {
                case .inactive: return ""
                case .loading: return "Loading..."
                case .active(let text): return text ?? ""
                case .error: return "Cannot load subtitles."
                }
            }()
            
            subtitlesTextLabelHidden = props.player?.item.playable?.legible.external?.external.available?.isInactive ?? false
            
            thumbnailImageViewHidden = props.player?.item.playable?.thumbnail?.url == nil
            
            thumbnailImageUrl = props.player?.item.playable?.thumbnail?.url
            
            errorLabelText = props.player?.item.nonplayable ?? props.player?.item.playable?.error?.message ?? ""
            
            errorLabelHidden = (props.player?.item.nonplayable == nil) && (props.player?.item.playable?.error == nil)
            
            retryButtonHidden = props.player?.item.playable?.error == nil
            
            retryButtonCommand = props.player?.item.playable?.error?.retryCommand ?? .nop
            
            pipButtonHidden = props.player?.item.playable?.pictureInPictureControl.isUnsupported ?? true
            
            pipButtonEnabled = props.player?.item.playable?.pictureInPictureControl.possible != nil
            
            pipButtonCommand = props.player?.item.playable?.pictureInPictureControl.possible ?? .nop
            
            settingsButtonHidden = props.player?.item.playable?.settings.isHidden ?? true
            
            settingsButtonEnabled = props.player?.item.playable?.settings.enabled != nil
            
            settingsButtonCommand = props.player?.item.playable?.settings.enabled ?? .nop
            
            airplayActiveLabelHidden = !(props.player?.item.playable?.airplay.isActive ?? false)
            airplayButtonHidden = props.player?.item.playable?.airplay.isHidden ?? true
            
            liveIndicationViewIsHidden = props.player?.item.playable?.live.isHidden ?? true
            
            liveDotColor = props.player?.item.playable?.live.dotColor ?? nil
            
            compassViewBelowLive = {
                guard
                    props.player?.item.playable?.camera != nil,
                    props.player?.item.playable?.live.isHidden == false
                    else { return false }
                return true
            }()
        }
    }
}
