{-|
Module      : BreadU.Pages.CSS.Own
Description : Own CSS for all pages.
Stability   : experimental
Portability : POSIX

Owr own CSS for all pages. It will be embedded in <head>-tag.

We're using Clay DSL to create CSS. In this case successful compilation
guarantees that produces CSS is valid. Produced CSS is minified.
-}

module BreadU.Pages.CSS.Own
    ( ownCss
    ) where

import           BreadU.Pages.CSS.Names     ( ClassName(..) )

import           Clay
import           Clay.Selector              ( Selector, text )
import           Hasmin                     ( minifyCSS )
import           TextShow                   ( showt )
import           Data.Monoid                ( (<>) )
import           Data.Text                  ( Text )
import qualified Data.Text.Lazy             as Lazy

-- | Build CSS and renders it as a Text.
ownCss :: Text
ownCss = minify . Lazy.toStrict . render $ do
    -- There's one monadic context Css. So we can compose whole CSS
    -- from different parts in the same context.
    body ? do
        fontSizeEm      1.1
        backgroundColor "#f4f3ef"
        mainFont
        paddingTopEm    2.0
        paddingBottomEm 2.0
 
    simpleLinks

    h1 ? do
        fontSizeEm      1.9
        paddingTopEm    1.2
        paddingBottomEm 1.2
        centerAlign

    h4 ? do
        paddingTopEm    1.0
        paddingBottomEm 0.7

    cl LanguageSwitcher ?
        fontSizeEm      1.15

    cl LanguageSwitcherDelimiter ? do
        paddingLeftEm   1.0
        paddingRightEm  1.0

    cl CurrentLanguage ? do
        borderBottom    solid (px 2) linksColor
        paddingBottomEm 0.3

    cl AboutInfo ?
        fontSizeEm      0.95

    cl FormBlock ? do
        marginAuto
        maxWidth        (em 30.0)

    input # "type=text" ? do
        fontSizeEm      1.4
        mainFont

    cl FoodFormRowsSeparator ?
        paddingTopEm    0.5

    cl FoodFormFirstItem ? do
        paddingLeftEm   0.05
        paddingRightEm  0.05
    
    cl FoodFormItem ? do
        paddingTopEm    1.3
        marginTopEm     1.2
        marginBottomEm  1.2
        borderLeft      solid (px 1) "#ddd"
        borderRight     solid (px 1) "#ddd"
        position        relative

    cl FoodFormItemInputs ? do
        paddingTopEm    0.35
        paddingLeftEm   1.2
        paddingRightEm  1.2

    cl FoodNameInfo ? do
        paddingTopEm    1.2
        fontSizeEm      1.4

    cl FoodAmountInfo ? do
        paddingTopEm    2.2
        fontSizeEm      1.4

    cl AddFood ?
        paddingTopEm    3.2
    
    cl AddFoodButton ? do
        "padding-left"  -: "0.1em !important"
        "padding-right" -: "0.1em !important"
        borderRadius    (em 1.65) (em 0) (em 0) (em 1.65)

    cl Calculate ?
        paddingTopEm    3.2

    cl CalculateButton ?
        borderRadius    (em 0) (em 1.65) (em 1.65) (em 0)

    cl MainButtonIcon ?
        color           "#f5f5f5"

    cl MainButtonIconSeparator ?
        paddingLeftEm   1.0

    cl InfoIconFoodForm ? do
        paddingTopEm    0.4
        rightAlign
        fontSizeEm      1.4

    cl RemoveIconFoodForm ? do
        fontSizeEm      2.0
        color           "#aaa"
        position        absolute
        top             (em 0) 
        right           (em 0)
        marginTopEm     (-0.5)
        marginRightEm   0.15
    
    footer ? do
        paddingTopEm    3.5
        paddingBottomEm 2.5

    cl AuthorInfo ? do
        paddingTopEm    2.0
        color           "#888"
        fontSizeEm      0.9

    cl AuthorInfoMailToSeparator ?
        paddingLeftEm   1.1

    cl MailToIcon ?
        fontSizeEm      1.2

    cl SocialButtons ? do
        paddingTopEm    2.0
        rightAlign

    cl SocialButtonsSeparator ?
        paddingLeftEm   1.0

    cl Block404 ? do
        paddingTopEm    5.0
        centerAlign

    cl Block404Mark ?
        fontSizeEm      8.0

    cl Block404Mark0 ? do
        color           "#5899ff"
        fontSizeEm      1.05
        paddingLeftEm   0.09
        paddingRightEm  0.1

    cl Block404Description ?
        fontSizeEm      1.05

    -- | These classes aren't mine, it's from Bootstrap Material Design.
    ".btn-rounded" ?
        borderRadiusAll (em 10)
  where
    centerAlign     = textAlign . alignSide $ sideCenter
    rightAlign      = textAlign . alignSide $ sideRight

    paddingTopEm    = paddingTop . em
    paddingBottomEm = paddingBottom . em
    paddingLeftEm   = paddingLeft . em
    paddingRightEm  = paddingRight . em

    marginTopEm     = marginTop . em
    marginBottomEm  = marginBottom . em
    marginRightEm   = marginRight . em
    marginAuto      = margin (em 0) auto (em 0) auto

    fontSizeEm      = fontSize . em

    borderRadiusAll r = borderRadius r r r r
    
    mainFont = fontFamily ["Comfortaa", "Helvetica Neue", "Calibri Light", "Roboto"] [sansSerif]

    simpleLinks = do
        a           ? color linksColor
        a # hover   ? textDecoration none
        a # link    ? textDecoration none
        a # visited ? textDecoration none
        a # active  ? textDecoration none

    linksColor = "#1b95e0"

-- | Minify CSS. We shouldn't check 'Left'-variant from 'minifyCSS' function
-- because we're minifying generated CSS and assuming that it's definitely valid. ;-)
minify :: Text -> Text
minify css = let (Right minified) = minifyCSS css in minified

-- | Convert class name as a constructor to 'Selector' (via constructor's 'Text'-representation).
cl :: ClassName -> Selector
cl className = text $ "." <> showt className
