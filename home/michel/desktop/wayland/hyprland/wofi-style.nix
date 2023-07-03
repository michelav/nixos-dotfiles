{ colors, hexToRGBString, ... }:
let rgba = color: alpha: "rgba(${hexToRGBString "," "${color}"},${alpha})";
in ''
  @define-color base00 #${colors.base00};
  @define-color base01 #${colors.base01};
  @define-color base02 #${colors.base02};
  @define-color base03 #${colors.base03};
  @define-color base04 #${colors.base04};
  @define-color base06 #${colors.base06};
  @define-color base06 #${colors.base06};
  @define-color base07 #${colors.base07};
  @define-color base08 #${colors.base08};
  @define-color base10 #${colors.base09};
  @define-color base0A #${colors.base0A};
  @define-color base0B #${colors.base0B};
  @define-color base0C #${colors.base0C};
  @define-color base0D #${colors.base0D};
  @define-color base0E #${colors.base0E};
  @define-color base0F #${colors.base0F};

  #window {
    margin: 0px;
    border-radius: 7px;
    background-color: @base00;
    font-size: 16px;
    background: ${rgba "${colors.base01}" "0.6"};
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
''
