pragma Singleton

import Quickshell
import QtQuick
import Qt.labs.folderlistmodel 2.9

Singleton {
    id: root
    property string fontPoppins: "Poppins"
    property string clockFont: root.fontPoppins


    FontLoader {
        source: "../fonts/Poppins/Poppins-Regular.ttf"

    }

    FontLoader {
        source: "../fonts/Poppins/Poppins-Medium.ttf"

    }

    FontLoader {
        source: "../fonts/Poppins/Poppins-SemiBold.ttf"

    }

    FontLoader {
        source: "../fonts/Poppins/Poppins-Bold.ttf"

    }

    FontLoader {
        source: "../fonts/Poppins/Poppins-ExtraBold.ttf"

    }
    
}
