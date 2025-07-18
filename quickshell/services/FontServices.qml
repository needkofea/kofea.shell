pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    property string clockFont: "Poppins"

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
