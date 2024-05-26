{
    Copyright (C) 2024 VCC
    creation date: 26 May 2024
    initial release date: 26 May 2024

    author: VCC
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
    OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}


unit FindWindowsPluginProperties;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ClickerUtils;


const
  CMaxRequiredSubControlActions = 8;
  CAdditionalPropertiesCount = 3;
  CPropertiesCount = CMaxRequiredSubControlActions + CAdditionalPropertiesCount;

  CParentFindControlPropertyName = 'ParentFindControl';
  CBorderThicknessPropertyName = 'BorderThickness';
  CMatchWindowEdgesPropertyName = 'MatchWindowEdges';

  CFindSubControlTopLeftCorner_PropIndex = 0;
  CFindSubControlBotLeftCorner_PropIndex = 1;
  CFindSubControlTopRightCorner_PropIndex = 2;
  CFindSubControlBotRightCorner_PropIndex = 3;
  CFindSubControlLeftEdge_PropIndex = 4;
  CFindSubControlTopEdge_PropIndex = 5;
  CFindSubControlRightEdge_PropIndex = 6;
  CFindSubControlBottomEdge_PropIndex = 7;
  CParentFindControl_PropIndex = 8;
  CBorderThickness_PropIndex = 9;
  CMatchWindowEdges_PropIndex = 10;

  CRequiredSubControlPropertyNames: array[0..CPropertiesCount - 1] of string = (  //these are the expected FindSubControl property names, configured in plugin properties
    'FindSubControlTopLeftCorner',
    'FindSubControlBotLeftCorner',
    'FindSubControlTopRightCorner',
    'FindSubControlBotRightCorner',
    'FindSubControlLeftEdge',
    'FindSubControlTopEdge',
    'FindSubControlRightEdge',
    'FindSubControlBottomEdge',

    CParentFindControlPropertyName,  //This action is called before every FindSubControl action above. It can also be a CallTemplate action (with FindControl and FindSubControl). It is required to prepare the $Control_Left$ and $Control_Top$ vars for every FindSubControl.
    CBorderThicknessPropertyName,
    CMatchWindowEdgesPropertyName
  );

  //See TOIEditorType datatype from ObjectInspectorFrame.pas, for valid values
  CRequiredSubControlPropertyTypes: array[0..CPropertiesCount - 1] of string = (
    'TextWithArrow',
    'TextWithArrow',
    'TextWithArrow',
    'TextWithArrow',
    'TextWithArrow',
    'TextWithArrow',
    'TextWithArrow',
    'TextWithArrow',

    'TextWithArrow',      //CParentFindControlPropertyName
    'SpinText',           //CBorderThicknessPropertyName
    'BooleanCombo'        //CMatchWindowEdgesPropertyName
  );

  CRequiredSubControlPropertyDataTypes: array[0..CPropertiesCount - 1] of string = (
    CDTString,  //'FindSubControlTopLeftCorner',
    CDTString,  //'FindSubControlBotLeftCorner',
    CDTString,  //'FindSubControlTopRightCorner',
    CDTString,  //'FindSubControlBotRightCorner',
    CDTString,  //'FindSubControlLeftEdge',
    CDTString,  //'FindSubControlTopEdge',
    CDTString,  //'FindSubControlRightEdge',
    CDTString,  //'FindSubControlBottomEdge',

    CDTString,  //CParentFindControlPropertyName,  //This action is called before every FindSubControl action above. It can also be a CallTemplate action (with FindControl and FindSubControl). It is required to prepare the $Control_Left$ and $Control_Top$ vars for every FindSubControl.
    CDTInteger,  //CBorderThicknessPropertyName,
    CDTBool  //CMatchWindowEdgesPropertyName
  );

  CPluginEnumCounts: array[0..CPropertiesCount - 1] of Integer = (
    0,  //'FindSubControlTopLeftCorner',
    0,  //'FindSubControlBotLeftCorner',
    0,  //'FindSubControlTopRightCorner',
    0,  //'FindSubControlBotRightCorner',
    0,  //'FindSubControlLeftEdge',
    0,  //'FindSubControlTopEdge',
    0,  //'FindSubControlRightEdge',
    0,  //'FindSubControlBottomEdge',

    0,  //CParentFindControlPropertyName,  //This action is called before every FindSubControl action above. It can also be a CallTemplate action (with FindControl and FindSubControl). It is required to prepare the $Control_Left$ and $Control_Top$ vars for every FindSubControl.
    0,  //CBorderThicknessPropertyName,
    0  //CMatchWindowEdgesPropertyName
  );

  CPluginEnumStrings: array[0..CPropertiesCount - 1] of string = (
    '',  //'FindSubControlTopLeftCorner',
    '',  //'FindSubControlBotLeftCorner',
    '',  //'FindSubControlTopRightCorner',
    '',  //'FindSubControlBotRightCorner',
    '',  //'FindSubControlLeftEdge',
    '',  //'FindSubControlTopEdge',
    '',  //'FindSubControlRightEdge',
    '',  //'FindSubControlBottomEdge',

    '',  //CParentFindControlPropertyName,  //This action is called before every FindSubControl action above. It can also be a CallTemplate action (with FindControl and FindSubControl). It is required to prepare the $Control_Left$ and $Control_Top$ vars for every FindSubControl.
    '',  //CBorderThicknessPropertyName,
    ''  //CMatchWindowEdgesPropertyName
  );

  CPluginHints: array[0..CPropertiesCount - 1] of string = (
    'Name of a FindSubControl action, called by this plugin, to find the Top-Left corner of all windows.',  //'FindSubControlTopLeftCorner',
    'Name of a FindSubControl action, called by this plugin, to find the Bot-Left corner of all windows.',  //'FindSubControlBotLeftCorner',
    'Name of a FindSubControl action, called by this plugin, to find the Top-Right corner of all windows.',  //'FindSubControlTopRightCorner',
    'Name of a FindSubControl action, called by this plugin, to find the Bot-Right corner of all windows.',  //'FindSubControlBotRightCorner',
    'Name of a FindSubControl action, called by this plugin, to find the Left edge of all windows.',  //'FindSubControlLeftEdge',
    'Name of a FindSubControl action, called by this plugin, to find the Top edge of all windows.',  //'FindSubControlTopEdge',
    'Name of a FindSubControl action, called by this plugin, to find the Right edge of all windows.',  //'FindSubControlRightEdge',
    'Name of a FindSubControl action, called by this plugin, to find the Bottom edge of all windows.',  //'FindSubControlBottomEdge',

    'Name of a FindControl action, called by this plugin, to prepare the control handle, required by the FindSubControl actions.',  //CParentFindControlPropertyName,  //This action is called before every FindSubControl action above. It can also be a CallTemplate action (with FindControl and FindSubControl). It is required to prepare the $Control_Left$ and $Control_Top$ vars for every FindSubControl.
    'Number of pixels, for width or height (or both), to crop from a window (corner or edge), to verify if it matches.',  //CBorderThicknessPropertyName,
    'If True, it also verifies window edges in addition to corners. If False, FindSubControl actions, for edges, are not called.'  //CMatchWindowEdgesPropertyName
  );

  CPropertyEnabled: array[0..CPropertiesCount - 1] of string = (  // The 'PropertyValue[<index>]' replacement uses indexes from the following array only. It doesn't count fixed properties.
    '',  //'FindSubControlTopLeftCorner',                         // If empty string, the property is unconditionally enabled. For available operators, see CComp constans in ClickerUtils.pas.
    '',  //'FindSubControlBotLeftCorner',                         // Multiple conditions can be ANDed using the #5#6 separator. E.g.: 'PropertyValue[10]==True' + #5#6 + 'PropertyValue[11]==True'
    '',  //'FindSubControlTopRightCorner',
    '',  //'FindSubControlBotRightCorner',
    'PropertyValue[10]==True',  //'FindSubControlLeftEdge',
    'PropertyValue[10]==True',  //'FindSubControlTopEdge',
    'PropertyValue[10]==True',  //'FindSubControlRightEdge',
    'PropertyValue[10]==True',  //'FindSubControlBottomEdge',

    '',  //CParentFindControlPropertyName,  //This action is called before every FindSubControl action above. It can also be a CallTemplate action (with FindControl and FindSubControl). It is required to prepare the $Control_Left$ and $Control_Top$ vars for every FindSubControl.
    '',  //CBorderThicknessPropertyName,
    ''  //CMatchWindowEdgesPropertyName
  );

  CPluginDefaultValues: array[0..CPropertiesCount - 1] of string = (  // The 'PropertyValue[<index>]' replacement uses indexes from the following array only. It doesn't count fixed properties.
    '',  //'FindSubControlTopLeftCorner',                         // If empty string, the property is unconditionally enabled. For available operators, see CComp constans in ClickerUtils.pas.
    '',  //'FindSubControlBotLeftCorner',                         // Multiple conditions can be ANDed using the #5#6 separator. E.g.: 'PropertyValue[10]==True' + #5#6 + 'PropertyValue[11]==True'
    '',  //'FindSubControlTopRightCorner',
    '',  //'FindSubControlBotRightCorner',
    '',  //'FindSubControlLeftEdge',
    '',  //'FindSubControlTopEdge',
    '',  //'FindSubControlRightEdge',
    '',  //'FindSubControlBottomEdge',

    '',  //CParentFindControlPropertyName,  //This action is called before every FindSubControl action above. It can also be a CallTemplate action (with FindControl and FindSubControl). It is required to prepare the $Control_Left$ and $Control_Top$ vars for every FindSubControl.
    '6',  //CBorderThicknessPropertyName,
    'True'  //CMatchWindowEdgesPropertyName
  );


function FillInPropertyDetails: string;


implementation


uses
  ClickerActionPlugins;


function FillInPropertyDetails: string;
var
  i: Integer;
begin
  Result := '';

  for i := 0 to CPropertiesCount - 1 do
    Result := Result + CRequiredSubControlPropertyNames[i] + '=' + CRequiredSubControlPropertyTypes[i] + #8#7 +
                       CPluginPropertyAttr_DataType + '=' + CRequiredSubControlPropertyDataTypes[i] + #8#7 +
                       CPluginPropertyAttr_EnumCounts + '=' + IntToStr(CPluginEnumCounts[i]) + #8#7 +
                       CPluginPropertyAttr_EnumStrings + '=' + CPluginEnumStrings[i] + #8#7 +
                       CPluginPropertyAttr_Hint + '=' + CPluginHints[i] + #8#7 +
                       CPluginPropertyAttr_Enabled + '=' + CPropertyEnabled[i] + #8#7 +
                       CPluginPropertyAttr_DefaultValue + '=' + CPluginDefaultValues[i] + #8#7 +
                       #13#10;
end;

end.

