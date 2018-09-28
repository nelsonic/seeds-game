module Types exposing
    ( Flags
    , HasScene
    , Model
    , Msg(..)
    , RawProgress
    , Scene(..)
    , SceneState(..)
    , SceneTransition
    , Times
    )

import Data.Background exposing (Background)
import Data.InfoWindow exposing (InfoWindow)
import Data.Level.Types exposing (LevelData, Progress)
import Data.Visibility exposing (Visibility)
import Data.Window as Window
import Scenes.Hub.Types exposing (HubModel, HubMsg)
import Scenes.Intro.Types exposing (IntroModel, IntroMsg)
import Scenes.Level.Types exposing (LevelModel, LevelMsg)
import Scenes.Tutorial.Types exposing (TutorialConfig, TutorialModel, TutorialMsg)
import Time exposing (Posix)


type alias Flags =
    { now : Float
    , times : Maybe Times
    , rawProgress : Maybe RawProgress
    }


type alias Times =
    { timeTillNextLife : Float
    , lastPlayed : Float
    }


type alias RawProgress =
    { world : Int
    , level : Int
    }


type alias Model =
    { scene : SceneState
    , loadingScreen : Maybe Background
    , progress : Progress
    , currentLevel : Maybe Progress
    , timeTillNextLife : Float
    , lastPlayed : Float
    , hubInfoWindow : InfoWindow Progress
    , titleAnimation : Visibility
    , successMessageIndex : Int
    , window : Window.Size
    }


type SceneState
    = Transition SceneTransition
    | Loaded Scene


type alias SceneTransition =
    { from : Scene
    , to : Scene
    }


type alias HasScene a =
    { a | scene : SceneState }


type Scene
    = Title
    | Level LevelModel
    | Tutorial TutorialModel
    | Intro IntroModel
    | Hub
    | Summary
    | Retry


type Msg
    = LevelMsg LevelMsg
    | TutorialMsg TutorialMsg
    | IntroMsg IntroMsg
    | HubMsg HubMsg
    | GenerateSuccessMessageIndex Int
    | IncrementSuccessMessageIndex
    | StartLevel Progress
    | RestartLevel
    | LevelWin
    | LevelLose
    | LoadTutorial Progress TutorialConfig
    | LoadLevel Progress
    | LoadIntro
    | LoadHub Int
    | LoadSummary
    | LoadRetry
    | FadeTitle
    | CompleteSceneTransition
    | ShowLoadingScreen
    | HideLoadingScreen
    | RandomBackground Background
    | SetCurrentLevel (Maybe Progress)
    | GoToHub
    | GoToIntro
    | IntroMusicPlaying Bool
    | ClearCache
    | WindowSize Int Int
    | UpdateTimes Posix
      -- Summary and Retry
    | IncrementProgress
    | DecrementLives
