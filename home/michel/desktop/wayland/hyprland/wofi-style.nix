{ palette, hexToRGBString, ... }:
let rgba = color: alpha: "rgba(${hexToRGBString "," "${color}"},${alpha})";
in ''
  @define-color base00 #${palette.base00};
  @define-color base01 #${palette.base01};
  @define-color base02 #${palette.base02};
  @define-color base03 #${palette.base03};
  @define-color base04 #${palette.base04};
  @define-color base06 #${palette.base06};
  @define-color base06 #${palette.base06};
  @define-color base07 #${palette.base07};
  @define-color base08 #${palette.base08};
  @define-color base10 #${palette.base09};
  @define-color base0A #${palette.base0A};
  @define-color base0B #${palette.base0B};
  @define-color base0C #${palette.base0C};
  @define-color base0D #${palette.base0D};
  @define-color base0E #${palette.base0E};
  @define-color base0F #${palette.base0F};

  #window {
    margin: 0px;
    border-radius: 7px;
    background-color: @base00;
    font-size: 16px;
    background: ${rgba "${palette.base01}" "0.6"};
  }

  #input {
    margin: 15px;
    border: 2px solid @base04;
    border-radius: 10px;
    color: @base05;
    background: @base01;
  }

  #input:focus {
    background: @base02;
  }

  #input:focus image {
    color: @base04;
  }

  #input image {
  	color: @base04;
  }

  #inner-box {
    margin: 5px;
    border: none;
    padding-left: 10px;
    padding-right: 10px;
    border-radius: 7px;
    background-color: inherit;
  }

  #outer-box {
    margin: 5px;
    border: none;
    background-color: inherit;
    border-radius: 7px;
  }

  #scroll {
    margin: 0px;
    border: none;
  }

  #text {
    margin: 5px;
    border: none;
    color: @base06;
  } 

  #entry:selected {
  	border-radius: 10px;
   background: @base0D;
  }

  #text:selected {
  	background-color: inherit;
  	color: @base00;
    font-weight: normal;
  }
''
