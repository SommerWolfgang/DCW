table 6085580 "CDC Template Field"
{
    Caption = 'Template Field';
    DataCaptionFields = Type, "Code", "Field Name";

    fields
    {
        field(1; "Template No."; Code[20])
        {
            Caption = 'Template No.';
            NotBlank = true;
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
        }
        field(3; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(4; "Data Type"; Option)
        {
            Caption = 'Data Type';
            OptionCaption = 'Text,Number,Date,Boolean,,,,,Lookup';
            OptionMembers = Text,Number,Date,Boolean,,,,,_Lookup;
        }
        field(5; Required; Boolean)
        {
            Caption = 'Required';
        }
        field(6; "Search for Value"; Boolean)
        {
            Caption = 'Search for Value';
        }
        field(7; "Caption Is Part Of Value"; Boolean)
        {
            Caption = 'Caption Is Part Of Value';
        }
        field(8; "Insert on new Templates"; Boolean)
        {
            Caption = 'Insert on new Templates';
            InitValue = true;
        }
        field(9; "Number Has Decimals"; Boolean)
        {
            Caption = 'Number Has Decimals';
        }
        field(10; "Caption Offset X"; Integer)
        {
            Caption = 'Caption Offset X';
        }
        field(11; "Caption Offset Y"; Integer)
        {
            Caption = 'Caption Offset Y';
        }
        field(12; "Fixed Value (Text)"; Text[250])
        {
            Caption = 'Fixed Value (Text)';
        }
        field(13; "Fixed Value (Decimal)"; Decimal)
        {
            Caption = 'Fixed Value (Decimal)';
        }
        field(14; "Fixed Value (Date)"; Date)
        {
            Caption = 'Fixed Value (Date)';
        }
        field(15; "Fixed Value (Lookup)"; Code[20])
        {
            Caption = 'Fixed Value (Lookup)';
        }
        field(17; "Validation Dateformula From"; DateFormula)
        {
            Caption = 'Validation Dateformula From';
        }
        field(18; "Validation Dateformula To"; DateFormula)
        {
            Caption = 'Validation Dateformula To';
        }
        field(19; "Never use Global Captions"; Boolean)
        {
            Caption = 'Never use Global Captions';
            Description = 'Deprecated NAV';
            InitValue = true;
        }
        field(20; "Decimal Places"; Code[10])
        {
            Caption = 'Decimal Places';
        }
        field(21; "Blank Zero"; Boolean)
        {
            Caption = 'Blank Zero';
        }
        field(22; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(23; "Enable Rule Generation"; Boolean)
        {
            Caption = 'Enable Rule Generation';
        }
        field(24; Multiline; Boolean)
        {
            Caption = 'Multiline';
        }
        field(25; "Default Page Source"; Option)
        {
            Caption = 'Default Page Source';
            OptionCaption = 'First Page,Last Page';
            OptionMembers = "First Page","Last Page";
        }
        field(26; "Auto Update Caption"; Boolean)
        {
            Caption = 'Auto Update Caption';
            InitValue = true;
        }
        field(27; "Typical Field Width"; Decimal)
        {
            Caption = 'Field Width';
            DecimalPlaces = 0 : 5;
        }
        field(28; "Auto Update Field Width"; Boolean)
        {
            Caption = 'Auto Update Field Width';
            Description = 'Deprecated NAV';
            InitValue = true;
        }
        field(29; "Typical Field Height"; Decimal)
        {
            Caption = 'Field Height';
            DecimalPlaces = 0 : 5;
        }
        field(30; "Auto Update Field Height"; Boolean)
        {
            Caption = 'Auto Update Field Height';
            Description = 'Deprecated NAV';
            InitValue = true;
        }
        field(31; "Sort Order"; Integer)
        {
            Caption = 'Sort Order';
        }
        field(32; "Field Name"; Text[50])
        {
            Caption = 'Field Name';
        }
        field(33; "Stop Lines Recognition"; Option)
        {
            Caption = 'Stop Lines Recognition';
            OptionCaption = ' ,If Caption is on same line,If Value is on same line,If Caption or Value is on same line,If Caption is on same line (continue on next page),If Value is on same line (continue on next page),If Caption or Value is on same line (continue on next page)';
            OptionMembers = " ","If Caption is on same line","If Value is on same line","If Caption or Value is on same line","If Caption is on same line (continue on next page)","If Value is on same line (continue on next page)","If Caption or Value is on same line (continue on next page)";
        }
        field(34; "Make Absolute Number"; Boolean)
        {
            Caption = 'Make Absolute Number';
        }
        field(37; "Lookup Table"; Option)
        {
            Caption = 'Lookup Table';
            OptionCaption = ' ,Vendor,Contact,Customer,Job,Item,Fixed Asset,Employee,Dimension Value';
            OptionMembers = " ",Vendor,Contact,Customer,Job,Item,"Fixed Asset",Employee,"Dimension Value";
        }
        field(38; "Lookup Rel. Code"; Code[20])
        {
            Caption = 'Relation Code';
            TableRelation = if ("Lookup Table" = const("Dimension Value")) Dimension;
        }
        field(39; "Codeunit ID: Is OK"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Is OK';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Codeunit));
        }
        field(41; "Codeunit ID: Lookup"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Lookup';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Codeunit));
        }
        field(43; "Codeunit ID: Validate"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Validate';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Codeunit));
        }
        field(45; Formula; Code[250])
        {
            Caption = 'Formula';
        }
        field(46; "G/L Account Field Code"; Code[20])
        {
            Caption = 'G/L Account Field Code';
        }
        field(47; "Transfer Amount to Document"; Option)
        {
            Caption = 'Transfer Amount to Document';
            OptionCaption = ' ,If lines are not recognised,Always';
            OptionMembers = " ","If lines are not recognised",Always;
        }
        field(48; "Subtract from Amount Field"; Code[20])
        {
            Caption = 'Subtract from Amount Field (on registration)';
        }
        field(49; "Codeunit ID: Capture Value"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Capture Value';
        }
        field(51; "Purch. Alloc. G/L Account No."; Code[20])
        {
            Caption = 'Purch. Alloc. G/L Account No.';
        }
        field(52; "Date Format"; Option)
        {
            Caption = 'Date Format';
            OptionCaption = ' ,Day / Month / Year,Month / Day / Year,Year / Day / Month,Year / Month / Day,Day / Year / Month,Month / Year / Day';
            OptionMembers = " ","Day / Month / Year","Month / Day / Year","Year / Day / Month","Year / Month / Day","Day / Year / Month","Month / Year / Day";
        }
        field(53; "Source Table No."; Integer)
        {
            BlankZero = true;
            Caption = 'Source Table No.';
        }
        field(55; "Source Table Filter GUID"; Guid)
        {
            Caption = 'Source Table Filter GUID';
        }
        field(56; "Source Field No."; Integer)
        {
            BlankZero = true;
            Caption = 'Source Field No.';
        }
        field(57; "Destination Header Field No."; Integer)
        {
            BlankZero = true;
            Caption = 'Destination Header Field No.';
        }
        field(59; "Fixed Value (Rec. ID Tree ID)"; Integer)
        {
            Caption = 'Fixed Value (Rec. ID Tree ID)';
        }
        field(60; "Destination Line Field No."; Integer)
        {
            BlankZero = true;
            Caption = 'Destination Line Field No.';
        }
        field(61; "Delete Blanks"; Boolean)
        {
            Caption = 'Delete Blanks';
        }
        field(62; "Caption Mandatory"; Boolean)
        {
            Caption = 'Caption Mandatory';
        }
        field(63; "Use as Doc. Separator"; Boolean)
        {
            Caption = 'Use as Document Separator';

            trigger OnValidate()
            begin
                if not "Use as Doc. Separator" then
                    exit;

                TestField(Type, Type::Header);
            end;
        }
        field(64; "Fixed Value (Boolean)"; Boolean)
        {
            Caption = 'Fixed Value (Boolean)';
        }
        field(65; "Offset DPI"; Integer)
        {
            Caption = 'Offset DPI';
        }
        field(66; "Typical Field DPI"; Integer)
        {
            Caption = 'Typical Field DPI';
        }
        field(67; "Transfer Blank Values"; Boolean)
        {
            Caption = 'Transfer Blank Values';
        }
        field(68; "Calculate Date (Date Formula)"; DateFormula)
        {
            Caption = 'Calculate Date (Date Formula)';
        }
        field(100; "XML Path"; Text[250])
        {
            Caption = 'XML Path';
        }
        field(101; "Change Sign"; Boolean)
        {
            Caption = 'Change Sign';
        }
        field(102; "Show Field"; Option)
        {
            Caption = 'Show Field';
            OptionCaption = 'Never,If it has a value,Always';
            OptionMembers = Never,IfValue,Always;
        }
        field(50001; "Replacement Field"; Code[20])
        {
            Caption = 'Substitution Field';
        }
        field(50002; "Linked Field"; Code[20])
        {
            Caption = 'Anchor Field';
        }
        field(50003; Sorting; Integer)
        {
            Caption = 'Sorting';
        }
        field(50004; "Field value position"; Option)
        {
            Caption = 'Field position';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Above standard line,Below standard line';
            OptionMembers = " ",AboveStandardLine,BelowStandardLine;
        }
        field(50005; "Field value search direction"; Option)
        {
            Caption = 'Value search direction';
            DataClassification = CustomerContent;
            OptionCaption = 'Downwards,Upwards';
            OptionMembers = Downwards,Upwards;

            trigger OnValidate()
            begin
                TestField("Advanced Line Recognition Type", "Advanced Line Recognition Type"::FindFieldByColumnHeading);
            end;
        }
        field(50006; "Replacement Field Type"; Option)
        {
            Caption = 'Replacement field type';
            DataClassification = CustomerContent;
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;

            trigger OnValidate()
            begin
                if xRec."Replacement Field Type" <> Rec."Replacement Field Type" then
                    Clear(Rec."Replacement Field");
            end;
        }
        field(50007; "Copy Value from Previous Value"; Boolean)
        {
            Caption = 'Copy value from previous value';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Rec."Copy Value from Previous Value" then
                    Clear(Rec."Replacement Field");
            end;
        }
        field(50010; "Data version"; Integer)
        {
            Caption = 'ALR Data version';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50011; "Advanced Line Recognition Type"; Option)
        {
            Caption = 'Advanced Line Recognition Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Standard,Anchor linked field,Field search with caption,Field search with column heading';
            OptionMembers = Default,LinkedToAnchorField,FindFieldByCaptionInPosition,FindFieldByColumnHeading;
        }
        field(50012; "Offset Top"; Integer)
        {
            Caption = 'Offset Top';
            DataClassification = ToBeClassified;
        }
        field(50013; "Offset Bottom"; Integer)
        {
            Caption = 'Offset Height';
            DataClassification = ToBeClassified;
        }
        field(50014; "Offset Left"; Integer)
        {
            Caption = 'Offset Left';
            DataClassification = ToBeClassified;
        }
        field(50015; "Offset Right"; Integer)
        {
            Caption = 'Offset Width';
            DataClassification = ToBeClassified;
        }
        field(50020; "ALR Value Caption Offset X"; Integer)
        {
            Caption = 'Caption Offset X';
            DataClassification = ToBeClassified;
        }
        field(50021; "ALR Value Caption Offset Y"; Integer)
        {
            Caption = 'Caption Offset Y';
            DataClassification = ToBeClassified;
        }
        field(50022; "ALR Typical Value Field Width"; Decimal)
        {
            Caption = 'Field Width';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
    }

    keys
    {
        key(Key1; "Template No.", Type, "Code")
        {
            Clustered = true;
        }
        key(Key2; "Template No.", Type, "Sort Order")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Type, "Code", "Field Name", Required, "Search for Value")
        {
        }
    }
    procedure SyncFieldFromMaster()
    begin
    end;

    procedure Clone(FromCompany: Text[30]; FromField: Record "CDC Template Field"; CreatedFromMasterTemplate: Boolean)
    begin
    end;

    procedure SetFixedValue(Value: Text[250])
    begin
    end;

    procedure GetFixedValue(): Text[250]
    begin
    end;

    procedure FormulaOnLookup(var Text: Text[1024]): Boolean
    begin
        Text := '';
    end;

    procedure GetDestFieldCaption(FieldType: Option Header,Line) FieldCap: Text[250]
    begin
    end;

    procedure ValidateDecimalPlaces(DecimalPlacesDescriptionIn: Text[5]) DecimalPlacesDescriptionOut: Text[50]
    begin
    end;

    procedure CheckDecimalPlacesFormat(var DecimalPlaces: Text[5]) OK: Boolean
    begin
        DecimalPlaces := '';
    end;

    procedure ParseDecimalPlacesDescription(DecimalPlacesDescriptionIn: Text[50]) DecimalPlacesOut: Text[5]
    begin
    end;

    procedure SetFormula(FormulaTxt: Text[250])
    begin
    end;

    procedure IsFormulaValid(FormulaTxt: Text[250]; ShowError: Boolean): Boolean
    begin
    end;
}