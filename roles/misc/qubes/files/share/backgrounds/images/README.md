# Wallpapers

Clone this repository and update your `wallpaper_repository` variable in your Gas Station configuration so you can add default wallpapers by adding new wallpapers to your forked repository. The wallpapers will automatically be pulled every hour. Be sure to include the `https://` git link in your `wallpaper_repository` variable and also to make sure the repository is publicly accessible.

## Updating the Previews

If you would like to update this repository to include previews of your wallpapers, you can run this command:

```
LINE_NUMBER="$(grep -n "default wallpapers that are included with this repository are shown below" README.md | head -n 1 | cut -d: -f1)" && truncate -s `head -$LINE_NUMBER README.md | wc -c` README.md && while read BACKGROUND_FILE; do echo "" >> README.md && echo "### ${BACKGROUND_FILE}" >> README.md && echo "" >> README.md && echo '!['"${BACKGROUND_FILE}"']('"${BACKGROUND_FILE}"')' >> README.md; done< <(find . -mindepth 1 -maxdepth 1 -type f  -name "*.jpg" | sed 's/^.\///')
```

## Wallpaper Previews

The default wallpapers that are included with this repository are shown below (for your viewing pleasure):

### underwater-turtle.jpg

![underwater-turtle.jpg](underwater-turtle.jpg)

### green-aurora-sky.jpg

![green-aurora-sky.jpg](green-aurora-sky.jpg)

### elephant-shady-forrest.jpg

![elephant-shady-forrest.jpg](elephant-shady-forrest.jpg)

### sun-through-tree.jpg

![sun-through-tree.jpg](sun-through-tree.jpg)

### blue-snow-mountain.jpg

![blue-snow-mountain.jpg](blue-snow-mountain.jpg)

### tye-dye-sky.jpg

![tye-dye-sky.jpg](tye-dye-sky.jpg)

### autumn-straight-path.jpg

![autumn-straight-path.jpg](autumn-straight-path.jpg)

### aurora-stars.jpg

![aurora-stars.jpg](aurora-stars.jpg)

### trees-below-mountain.jpg

![trees-below-mountain.jpg](trees-below-mountain.jpg)

### above-blue-ocean.jpg

![above-blue-ocean.jpg](above-blue-ocean.jpg)

### stardust-bubbles.jpg

![stardust-bubbles.jpg](stardust-bubbles.jpg)

### lodge-at-night.jpg

![lodge-at-night.jpg](lodge-at-night.jpg)

### space-aurora.jpg

![space-aurora.jpg](space-aurora.jpg)

### looking-down-ocean-cliff.jpg

![looking-down-ocean-cliff.jpg](looking-down-ocean-cliff.jpg)

### colorful-jellyfish.jpg

![colorful-jellyfish.jpg](colorful-jellyfish.jpg)

### warm-stonehenge.jpg

![warm-stonehenge.jpg](warm-stonehenge.jpg)

### rocky-pond-ripple.jpg

![rocky-pond-ripple.jpg](rocky-pond-ripple.jpg)

### mountain-through-trees.jpg

![mountain-through-trees.jpg](mountain-through-trees.jpg)

### green-tree-stump.jpg

![green-tree-stump.jpg](green-tree-stump.jpg)

### mountains-on-the-lake.jpg

![mountains-on-the-lake.jpg](mountains-on-the-lake.jpg)

### waves-clashing-rock.jpg

![waves-clashing-rock.jpg](waves-clashing-rock.jpg)

### aurora-over-cliff.jpg

![aurora-over-cliff.jpg](aurora-over-cliff.jpg)

### blue-butter-flies.jpg

![blue-butter-flies.jpg](blue-butter-flies.jpg)

### light-through-ocean-surface.jpg

![light-through-ocean-surface.jpg](light-through-ocean-surface.jpg)

### dark-palm-trees.jpg

![dark-palm-trees.jpg](dark-palm-trees.jpg)

### ocean-wave-timelapse.jpg

![ocean-wave-timelapse.jpg](ocean-wave-timelapse.jpg)

### colorful-paint-splashes.jpg

![colorful-paint-splashes.jpg](colorful-paint-splashes.jpg)
