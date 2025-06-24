![GitHub release downloads](https://img.shields.io/github/downloads/Menco-Scripts/Menco_progressbar/total)


# Menco Progress Bar

**Menco\_progressbar** — a sleek, easy-to-use action progress bar for FiveM, lovingly inspired by the classic **time2rp**.

## 🚀 How to Use It

Just call the export like this:

```lua
exports['Menco_progressbar']:startProgress({
    text = "Drinking Water",       -- What the player sees while waiting
    duration = 4000,               -- How long it takes (in ms)
    freeze = true,                 -- Should the player be frozen during this?
    canCancel = true,              -- Can the player cancel the action?
    notify = "You finished drinking.",  -- Notification on success
    notify2 = "Refreshing!",       -- Optional second notification (just for fun)
    type = "success",              -- Notification style (success, error, info)

    anim = {                      -- Optional animation while the action runs
        dict = 'mp_player_intdrink',
        clip = 'loop_bottle',
    },

    prop = {                      -- Optional prop to hold or show
        model = `prop_ld_flow_bottle`,
        pos = vec3(0.03, 0.03, 0.02),
        rot = vec3(0.0, 0.0, -1.5),
    },
}, function(success)
    if success then
        print("Action completed 🎉")
    else
        print("Action cancelled ❌")
    end
end)
```

*Note:* You can customize pretty much everything here — text, animation, prop, and how the player interacts!

---

## 📷 Preview

Check it out! 👇

![Menco Progress Bar Preview](https://github.com/user-attachments/assets/bd0be654-5201-4b66-aa3d-db4e6b4d9545)

## 🛠️ Coming Soon

Stay tuned! I’m cooking up:

* Sound effects available through the config and exports
* More customizable styles and themes to match your server
* Customizable position, size, and colors to make it truly yours

---

## 🙌 Credits

Big shoutout to the **time2rp** team for the inspiration 🤘
Built with ❤️ by Menco.
