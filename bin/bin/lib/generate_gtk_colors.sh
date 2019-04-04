#!/bin/bash
source ~/bin/lib/colors.sh
nl=$'\n'
cat <<EOF > .config/gtk-3.0/gtk.css 
@define-color theme_base_color $base00;
@define-color theme_fg_color $base04;
@define-color theme_active_color $base02;
@define-color theme_insensitive_color $base04;
@define-color theme_insensitive_bg $base00;

@define-color theme_cursor_color $base0D;

/* fallback mode */
@define-color os_chrome_bg_color $base00;
@define-color os_chrome_fg_color $base04;
@define-color os_chrome_selected_bg_color $base06;
@define-color os_chrome_selected_fg_color $base02;

* {
    /* Pidgin */
    -GtkIMHtml-hyperlink-color: $base0D;
    -GtkIMHtml-hyperlink-visited-color: $base0E;
    -GtkIMHtml-hyperlink-prelight-color: $base07;

    /* Evolution */
    -GtkHTML-link-color: $base0D;
    -GtkHTML-vlink-color: $base0E;
    -GtkHTML-cite-color: $base0B;

    -GtkWidget-link-color: $base0D;
    -GtkWidget-visited-link-color: $base0E;
}

@import url("resource:///org/gnome/HighContrastInverse/a11y.css");
EOF
