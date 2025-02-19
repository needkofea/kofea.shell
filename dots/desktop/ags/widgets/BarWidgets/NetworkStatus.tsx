import { bind } from "astal";
import Network from "gi://AstalNetwork";

const network = Network.get_default();

export default function NetworkStatus() {
  return (
    <box cssClasses={["network-status"]}>
      {bind(network, "wifi").as((wifi) => {
        return (
          <button cssClasses={["wifi"]}>
            <box>
              {wifi == null ? (
                <>
                  <image iconName={"network-wireless-disabled"} />
                  <label label={"Wifi Disabled"} />
                </>
              ) : (
                <>
                  <image iconName={bind(wifi, "icon_name")} />

                  <label label={bind(wifi, "ssid")} />
                </>
              )}
            </box>
          </button>
        );
      })}
    </box>
  );
}
