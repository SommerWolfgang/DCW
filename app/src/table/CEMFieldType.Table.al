table 6086345 "CEM Field Type"
{
    Caption = 'Field Type';
    DataCaptionFields = "Code", Description;
    Permissions = TableData "CEM Table Filter Field EM" = r,
                  TableData "CEM Field Translation" = r;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;

            trigger OnValidate()
            begin
                if IsSystemField() and (CurrFieldNo <> 0) then
                    Error(NotAllowedToInsertSysFieldErr);
            end;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Integer,Text,Code,Decimal,Option,Boolean,Date,Address,Attendees,DateTime';
            OptionMembers = "Integer",Text,"Code",Decimal,Option,Boolean,Date,Address,Attendees,DateTime;
        }
        field(11; Length; Integer)
        {
            BlankZero = true;
            Caption = 'Length';
        }
        field(12; "Manual Lookup Values"; Boolean)
        {
            Caption = 'Manual Lookup Values';
        }
        field(15; "Source Table No."; Integer)
        {
            BlankZero = true;
            Caption = 'Source Table No.';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));

            trigger OnValidate()
            var
                TableFilterField: Record "CEM Table Filter Field EM";
            begin
                if "Source Table No." = xRec."Source Table No." then
                    exit;

                CheckLookupValuesOnCode();

                "Source Field No." := 0;
                "Source Description Field No." := 0;

                TableFilterField.SetRange("Table Filter GUID", "Source Table Filter GUID");
                TableFilterField.DeleteAll();
            end;
        }
        field(16; "Source Table Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Table),
                                                                           "Object ID" = field("Source Table No.")));
            Caption = 'Source Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Source Field No."; Integer)
        {
            BlankZero = true;
            Caption = 'Source Field No.';
        }
        field(19; "Source Description Field No."; Integer)
        {
            BlankZero = true;
            Caption = 'Source Description Field No.';
            TableRelation = Field."No." where(TableNo = field("Source Table No."));

            trigger OnValidate()
            begin
                if "Source Description Field No." = 0 then
                    exit;

                TestField("Source Table No.");
            end;
        }
        field(20; "No. of Lookup Values"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("CEM Lookup Value" where("Field Type Code" = field(Code)));
            Caption = 'No. of Lookup Values';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Source Field Name"; Text[80])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Source Table No."),
                                                              "No." = field("Source Field No.")));
            Caption = 'Source Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Description Field Name"; Text[80])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Source Table No."),
                                                              "No." = field("Source Description Field No.")));
            Caption = 'Description Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; Mandatory; Boolean)
        {
            Caption = 'Mandatory';

            trigger OnValidate()
            begin
                if Mandatory then
                    TestField(Editable, true);
            end;
        }
        field(45; Editable; Boolean)
        {
            Caption = 'Editable';
            InitValue = true;
        }
        field(50; "Last Update Date/Time"; DateTime)
        {
            Caption = 'Last Update Date Time';
            Editable = false;
        }
        field(55; "Source Table Filter GUID"; Guid)
        {
            Caption = 'Source Table Filter GUID';
        }
        field(58; "No. of Source Table Filters"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("CEM Table Filter Field EM" where("Table Filter GUID" = field("Source Table Filter GUID")));
            Caption = 'No. of Source Table Filters';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "System Field"; Boolean)
        {
            Caption = 'System Field';
        }
        field(110; "No. of Translations"; Integer)
        {
            CalcFormula = count("CEM Field Translation" where("Field Type Code" = field(Code)));
            Caption = 'No. of Translations';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120; "Decimal Places"; Text[5])
        {
            Caption = 'Decimal Places';
            Description = '0:2 or similar 2:2 is default';

            trigger OnValidate()
            begin
                if not (Type = Type::Decimal) then begin
                    Message(DecimalPlacesWarningMsg);
                    "Decimal Places" := '';
                    exit;
                end;

                if not CorrectDecimalPlacesFormat("Decimal Places") then
                    Error(ErrWrongDecimalPlaces);
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Source Table Filter GUID")
        {
        }
    }

    var
        _SkipSystemFieldCheck: Boolean;
        DecimalPlacesWarningMsg: Label 'Decimal Places only has a value when Type is Decimal.';
        ErrWrongDecimalPlaces: Label 'The format must be n:m where n and m are integers from 0 to 10.';
        FieldLengthWasChangedMsg: Label 'The possible values are determined by the Type. The Length was changed. ';
        FieldNotAllowedEditableErr: Label '%1 %2 cannot be editable. This field is automatically calculated.';
        FieldTypeMustBeTextOrCodeErr: Label '%1 must be either text or code.';
        FieldTypeWarningMsg: Label 'Length only has a value when Type is either Text, Code or Address.';
        LookupValuesAllowedOnCodeErr: Label 'Lookup Values can only be configured for Type = Code.';
        LookupValuesLine1Msg: Label 'The field %1 has %2 lookup values.';
        LookupValuesLine2Msg: Label 'The users of the Continia Expense App might experience performance issues and the synchronization process might be slow.';
        LookupValuesLine3Msg: Label 'Please consider if it the number of lookup values could be reduced by adding extra filters.';
        NotAllowedToChangeSysFieldErr: Label 'You are not allowed to change %1 on a system field.';
        NotAllowedToDeleteSysFieldErr: Label 'You are not allowed to delete a system field: %1';
        NotAllowedToInsertSysFieldErr: Label 'You are not allowed to create a system field.';
        NotAllowedToRenameSysFieldErr: Label 'You are not allowed to rename a system field.';
        OnlyOneAttendeesField: Label 'There is already a field of type Attendees: %1';
        Text005: Label 'The %1 must be part of the primary key of the %2.';
        UpdatingLookupValTxt: Label 'Updating Lookup Values\\#1##############################\@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';


    procedure CalcLookupValForAllFields()
    var
        FieldType: Record "CEM Field Type";
    begin
        if FieldType.FindSet() then
            repeat
                FieldType.FillLookupValuesForOneField();
            until FieldType.Next() = 0;
    end;

    procedure CalcLookupValForFieldAndParent(IsManualUpdate: Boolean)
    var
        FieldType: Record "CEM Field Type";
        TableFilterField: Record "CEM Table Filter Field EM";
    begin

        // Finds top level and goes trough children
        TableFilterField.SetCurrentKey("Table Filter GUID", "Filter Type", "Field Type Code");
        TableFilterField.SetRange("Table Filter GUID", "Source Table Filter GUID");
        TableFilterField.SetRange("Filter Type", TableFilterField."Filter Type"::"Field Type");
        TableFilterField.SetFilter("Field Type Code", '<>%1', '');
        if TableFilterField.FindSet() then
            // This field has a Parent
            repeat
                FieldType.Get(TableFilterField."Field Type Code");
                FieldType.CalcLookupValForFieldAndParent(IsManualUpdate);
            until TableFilterField.Next() = 0
        else begin
            FillLookupValuesForOneField();

            if IsManualUpdate then begin
                "Last Update Date/Time" := CurrentDateTime;
                Modify();
            end;

            // This field does not have a parent
            // If this field is a parent for others, we calculated for all children.
            Clear(TableFilterField);
            TableFilterField.SetCurrentKey("Filter Type", "Field Type Code");
            TableFilterField.SetRange("Filter Type", TableFilterField."Filter Type"::"Field Type");
            TableFilterField.SetRange("Field Type Code", Code);
            if TableFilterField.FindSet() then
                repeat
                    FieldType.SetCurrentKey("Source Table Filter GUID");
                    FieldType.SetRange("Source Table Filter GUID", TableFilterField."Table Filter GUID");
                    FieldType.FindFirst();

                    FieldType.FillLookupValuesForOneField();
                until TableFilterField.Next() = 0;
        end;
    end;


    procedure FillLookupValuesForOneField()
    begin
    end;

    procedure GetFieldCaptionForApp(): Text[50]
    begin
    end;

    procedure GetDimCode(): Code[20]
    var
        TableFilterField: Record "CEM Table Filter Field EM";
        Dimension: Record Dimension;
    begin
        if ("Source Table No." = DATABASE::"Dimension Value") and TableFilterField.Get("Source Table Filter GUID", 1) then
            if Dimension.Get(TableFilterField."Value (Text)") then
                exit(Dimension.Code);
    end;


    procedure GetFieldFromDim(Dim: Code[20]): Code[20]
    var
        FieldType: Record "CEM Field Type";
        TableFilterField: Record "CEM Table Filter Field EM";
        Dimension: Record Dimension;
    begin
        if not Dimension.Get(Dim) then
            exit(Dim);

        TableFilterField.SetRange("Table No.", DATABASE::"Dimension Value");
        TableFilterField.SetRange("Field No.", 1);
        TableFilterField.SetRange("Value (Text)", Dim);
        if TableFilterField.FindFirst() then begin
            FieldType.SetRange("Source Table Filter GUID", TableFilterField."Table Filter GUID");
            if FieldType.FindFirst() then
                exit(FieldType.Code);
        end;

        exit(Dim);
    end;


    procedure LookupTable(var Text: Text[30]): Boolean
    begin
        Text := '';
    end;

    procedure LookupField(var Text: Text[1024]; TableNo: Integer; xFieldNo: Integer; OnlyKeys: Boolean): Boolean
    begin
        Text := '';
    end;

    procedure LookupOptionString(TableID: Integer; FldNo: Integer; var NewValue: Text[250]): Boolean
    begin
    end;

    procedure LookupBoolean(TableID: Integer; FldNo: Integer; var NewValue: Text[250]): Boolean
    begin
    end;

    procedure GetParentFieldTypeCode() FieldTypeCode: Code[20]
    var
        TableFilterField: Record "CEM Table Filter Field EM";
    begin
        TableFilterField.SetRange("Table Filter GUID", "Source Table Filter GUID");
        TableFilterField.SetRange("Filter Type", TableFilterField."Filter Type"::"Field Type");
        if TableFilterField.FindSet() then
            exit(TableFilterField."Field Type Code");
    end;


    procedure IsSystemField(): Boolean
    begin
    end;

    procedure IsRequiredSystemField(Type: Integer): Boolean
    begin
    end;

    procedure CorrectDecimalPlacesFormat(var DecimalPlaces: Text[10]): Boolean
    begin
    end;

    procedure FormatDecimalPlaces(var DecimalPlaces: Text[10]): Boolean
    var
        Pos: Integer;
    begin
        Pos := StrPos(DecimalPlaces, ':');

        case Pos of
            0:
                begin
                    if not (StrLen(DecimalPlaces) = 1) then
                        exit(false);
                    DecimalPlaces := DecimalPlaces + ':' + DecimalPlaces;
                end;
            1:
                begin
                    if not (StrLen(DecimalPlaces) = 2) then
                        exit(false);
                    DecimalPlaces := '0' + DecimalPlaces;
                end;
            2:
                begin
                    if StrLen(DecimalPlaces) = 2 then
                        DecimalPlaces := DecimalPlaces + '9';
                end;
            else
                exit(false);
        end;

        if not (StrLen(DecimalPlaces) = 3) then
            exit(false);

        exit(true);
    end;


    procedure FieldIsOptionstring(TableID: Integer; FldNo: Integer): Boolean
    var
        "Field": Record "Field";
    begin
        if not Field.Get(TableID, FldNo) then
            exit(false);

        exit(Field.Type = Field.Type::Option);
    end;


    procedure FieldIsBoolean(TableID: Integer; FldNo: Integer): Boolean
    var
        "Field": Record "Field";
    begin
        if not Field.Get(TableID, FldNo) then
            exit(false);

        exit(Field.Type = Field.Type::Boolean);
    end;


    procedure GetFieldTypeCodeForTableID(TableID: Integer): Code[20]
    begin
    end;

    procedure IsSystemFieldForTable(TableID: Integer): Boolean
    begin
    end;

    procedure CheckLookupValuesOnCode()
    begin
    end;

    procedure CheckLookupValuesLimit(FieldTypeCode: Code[20]; SkipConfiguredCheck: Boolean; var Warning: Text[1024]) MaximumLookupValuesDetected: Boolean
    begin
    end;

    local procedure MaximumLookupValues(): Integer
    begin
    end;

    procedure CreateFieldType(FieldCode: Code[20]; FieldDescription: Text[50]; FieldDataType: Integer; FieldLength: Integer; FieldMandatory: Boolean; SourceTableNo: Integer; SourceFieldNo: Integer; SourceDescriptionFieldNo: Integer)
    begin
    end;

    procedure SetSkipSystemFieldCheck(SkipSystemFieldCheck: Boolean)
    begin
    end;
}