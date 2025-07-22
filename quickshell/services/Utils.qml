pragma Singleton

import Quickshell

Singleton {

    function trimText(s: string, maxLen: int ): string {
        
        if (s.length > maxLen) {
            return s.slice(0, maxLen - 3) + "...";
        }
        return s;
    }
}
