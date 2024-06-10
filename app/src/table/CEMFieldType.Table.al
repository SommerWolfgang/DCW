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
                if IsSystemField and (CurrFieldNo <> 0) then
                    Error(NotAllowedToInsertSysFieldErr);
            end;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                if Description = xRec.Description then
                    exit;

                if Description <> '' then
                    FieldTypeCodeMgt.CreateFieldDefaultTranslation(Code, Description);
            end;
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Integer,Text,Code,Decimal,Option,Boolean,Date,Address,Attendees,DateTime';
            OptionMembers = "Integer",Text,"Code",Decimal,Option,Boolean,Date,Address,Attendees,DateTime;

            trigger OnValidate()
            var
                ExpAttendee: Record "CEM Attendee";
                AttendeesFieldType: Record "CEM Field Type";
            begin
                if IsSystemField then
                    Error(NotAllowedToChangeSysFieldErr, FieldCaption(Type));

                CheckLookupValuesOnCode;

                case Type of
                    Type::Code:
                        Length := 20;
                    Type::Option:
                        Length := 20;
                    Type::Text:
                        Length := 30;
                    Type::Address:
                        Length := 50;
                    Type::Attendees:
                        Length := 100;
                    else
                        Length := 0;
                end;

                case Type of
                    Type::Decimal:
                        "Decimal Places" := '2:2';
                    else
                        "Decimal Places" := '';
                end;

                if (Type = Type::Attendees) and (xRec.Type <> Type::Attendees) then begin
                    AttendeesFieldType.SetRange(Type, Type::Attendees);
                    AttendeesFieldType.SetFilter(Code, '<>%1', Code);
                    if AttendeesFieldType.FindFirst then
                        Error(OnlyOneAttendeesField, AttendeesFieldType.Code);
                end;
            end;
        }
        field(11; Length; Integer)
        {
            BlankZero = true;
            Caption = 'Length';

            trigger OnValidate()
            var
                ExpAttendee: Record "CEM Attendee";
                NewLength: Integer;
            begin
                if IsSystemField then
                    Error(NotAllowedToChangeSysFieldErr, FieldCaption(Length));

                NewLength := Length;
                case Type of
                    Type::Code, Type::Option:
                        begin
                            if Length > 50 then
                                NewLength := 50;
                            if Length < 1 then
                                NewLength := 1;
                        end;
                    Type::Text, Type::Address, Type::Attendees:
                        begin
                            if Length > 250 then
                                NewLength := 250;
                            if Length < 1 then
                                NewLength := 1;
                        end;
                    else begin
                        Length := 0;
                        Message(FieldTypeWarningMsg)
                    end;
                end;

                if (Type in [Type::Text, Type::Code, Type::Address, Type::Attendees]) and (Length <> NewLength) then begin
                    Length := NewLength;
                    Message(FieldLengthWasChangedMsg);
                end;
            end;
        }
        field(12; "Manual Lookup Values"; Boolean)
        {
            Caption = 'Manual Lookup Values';
        }
        field(15; "Source Table No."; Integer)
        {
            BlankZero = true;
            Caption = 'Source Table No.';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));

            trigger OnValidate()
            var
                TableFilterField: Record "CEM Table Filter Field EM";
            begin
                if "Source Table No." = xRec."Source Table No." then
                    exit;

                CheckLookupValuesOnCode;

                "Source Field No." := 0;
                "Source Description Field No." := 0;

                TableFilterField.SetRange("Table Filter GUID", "Source Table Filter GUID");
                TableFilterField.DeleteAll;
            end;
        }
        field(16; "Source Table Name"; Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Table),
                                                                           "Object ID" = FIELD("Source Table No.")));
            Caption = 'Source Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Source Field No."; Integer)
        {
            BlankZero = true;
            Caption = 'Source Field No.';
            TableRelation = Field."No." WHERE(TableNo = FIELD("Source Table No."));

            trigger OnValidate()
            var
                RecIDMgt: Codeunit "CDC Record ID Mgt.";
            begin
                if "Source Field No." = xRec."Source Field No." then
                    exit;

                if "Source Field No." = 0 then
                    exit;

                TestField("Source Table No.");

                if not RecIDMgt.PartOfKey("Source Table No.", "Source Field No.") then
                    Error(Text005, FieldCaption("Source Field No."), FieldCaption("Source Table No."));
            end;
        }
        field(19; "Source Description Field No."; Integer)
        {
            BlankZero = true;
            Caption = 'Source Description Field No.';
            TableRelation = Field."No." WHERE(TableNo = FIELD("Source Table No."));

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
            CalcFormula = Count("CEM Lookup Value" WHERE("Field Type Code" = FIELD(Code)));
            Caption = 'No. of Lookup Values';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Source Field Name"; Text[80])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = FIELD("Source Table No."),
                                                              "No." = FIELD("Source Field No.")));
            Caption = 'Source Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Description Field Name"; Text[80])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = FIELD("Source Table No."),
                                                              "No." = FIELD("Source Description Field No.")));
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

            trigger OnValidate()
            begin
                if not Editable then
                    TestField(Mandatory, false);

                if Editable then
                    CheckFieldIsAllowedEditable;
            end;
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
            CalcFormula = Count("CEM Table Filter Field EM" WHERE("Table Filter GUID" = FIELD("Source Table Filter GUID")));
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
            CalcFormula = Count("CEM Field Translation" WHERE("Field Type Code" = FIELD(Code)));
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

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ConfiguredField: Record "CEM Configured Field Type";
        FieldTranslation: Record "CEM Field Translation";
        LookupValue: Record "CEM Lookup Value";
        TableFilterField: Record "CEM Table Filter Field EM";
    begin
        if not _SkipSystemFieldCheck then
            if IsSystemField then
                Error(NotAllowedToDeleteSysFieldErr, Code);

        LookupValue.SetRange("Field Type Code", Code);
        LookupValue.DeleteAll;

        FieldTranslation.SetRange("Field Type Code", Code);
        FieldTranslation.DeleteAll;

        TableFilterField.SetRange("Table Filter GUID", "Source Table Filter GUID");
        TableFilterField.DeleteAll;

        ConfiguredField.SetRange("Field Code", Code);
        ConfiguredField.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        "System Field" := IsSystemField;
    end;

    trigger OnModify()
    begin
        if Code in [FieldTypeCodeMgt.GetPerDiemDestCountryCode, FieldTypeCodeMgt.GetPerDiemDetDestCountryCode] then
            Error('');

        "Last Update Date/Time" := CurrentDateTime;
        "System Field" := IsSystemField;
    end;

    trigger OnRename()
    begin
        if CodeIsSystemField(xRec.Code) then
            Error(NotAllowedToRenameSysFieldErr);

        "Last Update Date/Time" := CurrentDateTime;
        "System Field" := false;
    end;

    var
        FieldTypeCodeMgt: Codeunit "CEM Field Type Code Mgt.";
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
        if FieldType.FindSet then
            repeat
                FieldType.FillLookupValuesForOneField;
            until FieldType.Next = 0;
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
        if TableFilterField.FindSet then
            // This field has a Parent
            repeat
                FieldType.Get(TableFilterField."Field Type Code");
                FieldType.CalcLookupValForFieldAndParent(IsManualUpdate);
            until TableFilterField.Next = 0
        else begin
            FillLookupValuesForOneField;

            if IsManualUpdate then begin
                "Last Update Date/Time" := CurrentDateTime;
                Modify;
            end;

            // This field does not have a parent
            // If this field is a parent for others, we calculated for all children.
            Clear(TableFilterField);
            TableFilterField.SetCurrentKey("Filter Type", "Field Type Code");
            TableFilterField.SetRange("Filter Type", TableFilterField."Filter Type"::"Field Type");
            TableFilterField.SetRange("Field Type Code", Code);
            if TableFilterField.FindSet then
                repeat
                    FieldType.SetCurrentKey("Source Table Filter GUID");
                    FieldType.SetRange("Source Table Filter GUID", TableFilterField."Table Filter GUID");
                    FieldType.FindFirst;

                    FieldType.FillLookupValuesForOneField;
                until TableFilterField.Next = 0;
        end;
    end;


    procedure FillLookupValuesForOneField()
    var
        FieldType: Record "CEM Field Type";
        LookupValue: Record "CEM Lookup Value";
        RecRef: RecordRef;
        ParentSourceFieldNoRef: FieldRef;
        SourceDescFieldRef: FieldRef;
        SourceNoFieldRef: FieldRef;
        InsertOK: Boolean;
        ParentOfParentCode: Code[20];
        PrimaryFieldValue: Code[50];
        Window: Dialog;
        ParentFieldNo: Integer;
        RecIndex: Integer;
        TotalCount: Integer;
    begin
        LookupValue.SetRange("Field Type Code", Code);
        LookupValue.SetRange(Manual, false);
        LookupValue.DeleteAll(true);

        if "Source Table No." <> 0 then begin
            TestField("Source Field No.");
            TestField("Source Description Field No.");

            RecRef.Open("Source Table No.");
            SetFixedFiltersOnRecRef(RecRef, "Source Table Filter GUID");

            if GuiAllowed then begin
                Window.Open(UpdatingLookupValTxt);
                TotalCount := RecRef.Count;
            end;

            if RecRef.FindSet then
                repeat
                    Clear(PrimaryFieldValue);
                    Clear(InsertOK);
                    ParentFieldNo := GetParentPKFieldNo("Source Table Filter GUID");
                    if ParentFieldNo <> 0 then begin
                        ParentSourceFieldNoRef := RecRef.Field(ParentFieldNo);
                        PrimaryFieldValue := ParentSourceFieldNoRef.Value;

                        if FieldType.Get(GetParentFieldTypeCode) then
                            ParentOfParentCode := FieldType.GetParentFieldTypeCode;

                        if LookupValue.Get(GetParentFieldTypeCode, ParentOfParentCode, PrimaryFieldValue) then
                            InsertOK := true;
                    end else
                        InsertOK := true;

                    if GuiAllowed then begin
                        RecIndex += 1;
                        Window.Update(1, Code);
                        Window.Update(2, Round(RecIndex / TotalCount * 10000, 1));
                    end;

                    if InsertOK then begin
                        SourceNoFieldRef := RecRef.Field("Source Field No.");
                        SourceDescFieldRef := RecRef.Field("Source Description Field No.");

                        if not LookupValue.Get(Code, PrimaryFieldValue, SourceNoFieldRef.Value) then begin
                            LookupValue.Init;
                            LookupValue."Field Type Code" := Code;
                            LookupValue."Parent Field Type Code" := PrimaryFieldValue;
                            LookupValue.Code := SourceNoFieldRef.Value;
                            LookupValue.Description := CopyStr(Format(SourceDescFieldRef.Value), 1, MaxStrLen(LookupValue.Description));
                            LookupValue.Insert;
                        end else begin
                            LookupValue.Description := CopyStr(Format(SourceDescFieldRef.Value), 1, MaxStrLen(LookupValue.Description));
                            LookupValue.Manual := false;
                            LookupValue.Modify;
                        end;
                    end;
                until RecRef.Next = 0;
            if GuiAllowed then
                Window.Close;
        end;

        AddLCY;
    end;


    procedure GetFieldCaptionForApp(): Text[50]
    var
        EMSetup: Record "CEM Expense Management Setup";
        FieldTranslation: Record "CEM Field Translation";
    begin
        EMSetup.Get;
        FieldTranslation.SetRange("Field Type Code", Code);
        FieldTranslation.SetRange("Language Code", EMSetup."Default Web/App Language");
        if FieldTranslation.FindFirst then
            exit(FieldTranslation.Translation)
        else
            if Description <> '' then
                exit(Description)
            else begin
                FieldTranslation.SetRange("Language Code");
                if FieldTranslation.FindFirst then
                    exit(FieldTranslation.Translation);
            end;
        exit(Code);
    end;

    local procedure AddLCY()
    var
        LookupValue: Record "CEM Lookup Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if "Source Table No." = DATABASE::Currency then begin
            GeneralLedgerSetup.Get;
            if GeneralLedgerSetup."LCY Code" <> '' then begin
                LookupValue.SetRange("Field Type Code", Code);
                LookupValue.SetRange(Code, GeneralLedgerSetup."LCY Code");
                if not LookupValue.FindFirst then begin
                    LookupValue.Init;
                    LookupValue."Field Type Code" := Code;
                    LookupValue.Code := GeneralLedgerSetup."LCY Code";
                    LookupValue.Description := GeneralLedgerSetup."LCY Code";
                    LookupValue.Insert;
                end;
            end;
        end;
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
        if TableFilterField.FindFirst then begin
            FieldType.SetRange("Source Table Filter GUID", TableFilterField."Table Filter GUID");
            if FieldType.FindFirst then
                exit(FieldType.Code);
        end;

        exit(Dim);
    end;


    procedure LookupTable(var Text: Text[30]): Boolean
    var
        AllObjWithCap: Record AllObjWithCaption;
        ObjId: Integer;
    begin
        if Evaluate(ObjId, Text) then;
        AllObjWithCap.SetRange("Object Type", AllObjWithCap."Object Type"::Table);

        if AllObjWithCap.Get(AllObjWithCap."Object Type"::Table, ObjId) then;
        if PAGE.RunModal(PAGE::"CDC Objects 2", AllObjWithCap) = ACTION::LookupOK then begin
            Text := Format(AllObjWithCap."Object ID");
            exit(true);
        end;
    end;


    procedure LookupField(var Text: Text[1024]; TableNo: Integer; xFieldNo: Integer; OnlyKeys: Boolean): Boolean
    var
        RecIDMgt: Codeunit "CDC Record ID Mgt.";
    begin
        if not Evaluate(xFieldNo, Text) then
            Text := Format(xFieldNo);

        exit(RecIDMgt.LookupField(Text, TableNo, OnlyKeys));
    end;


    procedure LookupOptionString(TableID: Integer; FldNo: Integer; var NewValue: Text[250]): Boolean
    var
        LookupTableTemp: Record "CEM Lookup Value Temp" temporary;
        LookupValuePage: Page "CEM Lookup Value";
        RecRef: RecordRef;
        SourceNoFieldRef: FieldRef;
    begin
        RecRef.Open(TableID);
        SourceNoFieldRef := RecRef.Field(FldNo);
        ParseOptionString(SourceNoFieldRef.OptionCaption, LookupTableTemp);

        SaveOriginalSelection(LookupTableTemp, NewValue, SourceNoFieldRef.OptionCaption);

        LookupValuePage.Editable := true;
        LookupValuePage.ReceiveRecords(LookupTableTemp);
        LookupValuePage.SetOptionTypeField;

        LookupValuePage.RunModal;
        LookupValuePage.ReturnRecords(LookupTableTemp);
        NewValue := CreateFilterString(LookupTableTemp);
        exit(true);
    end;

    local procedure ParseOptionString(TextOptString: Text[250]; var LookupTableTemp: Record "CEM Lookup Value Temp" temporary)
    var
        Pos: Integer;
    begin
        repeat
            Pos := StrPos(TextOptString, ',');

            LookupTableTemp."Entry No." += 1;
            if Pos <> 0 then
                LookupTableTemp.Value := CopyStr(TextOptString, 1, Pos - 1)
            else
                LookupTableTemp.Value := CopyStr(TextOptString, 1);
            LookupTableTemp.Insert;

            TextOptString := CopyStr(TextOptString, Pos + 1);
        until Pos = 0;
    end;


    procedure LookupBoolean(TableID: Integer; FldNo: Integer; var NewValue: Text[250]): Boolean
    var
        LookupTableTemp: Record "CEM Lookup Value Temp" temporary;
        RecRef: RecordRef;
        SourceNoFieldRef: FieldRef;
        Bool: Boolean;
    begin
        RecRef.Open(TableID);
        SourceNoFieldRef := RecRef.Field(FldNo);

        ParseOptionString(Format(Bool) + ',' + Format(not Bool), LookupTableTemp);

        LookupTableTemp.SetRange(Value, NewValue);
        if LookupTableTemp.FindFirst then;
        LookupTableTemp.SetRange(Value);
        if PAGE.RunModal(0, LookupTableTemp) = ACTION::LookupOK then begin
            NewValue := LookupTableTemp.Value;
            exit(true);
        end;
    end;

    local procedure SetFixedFiltersOnRecRef(var RecRef: RecordRef; SourceGUID: Guid): Boolean
    var
        TableFilterField: Record "CEM Table Filter Field EM";
        FieldRef: FieldRef;
        OldFilterGroup: Integer;
        Values: Text[100];
    begin
        OldFilterGroup := RecRef.FilterGroup;

        RecRef.FilterGroup(2);
        TableFilterField.SetCurrentKey("Table Filter GUID", "Filter Type");
        TableFilterField.SetRange("Table Filter GUID", SourceGUID);
        TableFilterField.SetRange("Filter Type", TableFilterField."Filter Type"::"Fixed Filter");
        if TableFilterField.FindSet then
            repeat
                FieldRef := RecRef.Field(TableFilterField."Field No.");
                TableFilterField.GetValues(Values, TableFilterField."Filter Type");
                if Format(FieldRef.Type) = 'Option' then
                    Values := TableFilterField.OptionStringToIntString(Values);
                FieldRef.SetFilter(Values);
            until TableFilterField.Next = 0;

        RecRef.FilterGroup(OldFilterGroup);

        exit(RecRef.FindSet);
    end;

    local procedure GetParentPKFieldNo(SourceGUID: Guid): Integer
    var
        TableFilterField: Record "CEM Table Filter Field EM";
    begin
        TableFilterField.SetCurrentKey("Table Filter GUID", "Filter Type");
        TableFilterField.SetRange("Table Filter GUID", SourceGUID);
        TableFilterField.SetRange("Filter Type", TableFilterField."Filter Type"::"Field Type");
        if TableFilterField.FindSet then
            exit(TableFilterField."Field No.");
    end;


    procedure GetParentFieldTypeCode() FieldTypeCode: Code[20]
    var
        TableFilterField: Record "CEM Table Filter Field EM";
    begin
        TableFilterField.SetRange("Table Filter GUID", "Source Table Filter GUID");
        TableFilterField.SetRange("Filter Type", TableFilterField."Filter Type"::"Field Type");
        if TableFilterField.FindSet then
            exit(TableFilterField."Field Type Code");
    end;


    procedure IsSystemField(): Boolean
    begin
        exit(
          (FieldTypeCodeMgt.GetExpSystemFieldNo(Code) <> -1) or
          (FieldTypeCodeMgt.GetMilSystemFieldNo(Code) <> -1) or
          (FieldTypeCodeMgt.GetPerDiemSystemFieldNo(Code) <> -1) or
          (FieldTypeCodeMgt.GetPerDiemDetailSystemFieldNo(Code) <> -1) or
          (FieldTypeCodeMgt.GetSettlementSystemFieldNo(Code) <> -1));
    end;

    local procedure CodeIsSystemField(FldCode: Code[20]): Boolean
    begin
        exit(
          (FieldTypeCodeMgt.GetExpSystemFieldNo(FldCode) <> -1) or
          (FieldTypeCodeMgt.GetMilSystemFieldNo(FldCode) <> -1) or
          (FieldTypeCodeMgt.GetPerDiemSystemFieldNo(FldCode) <> -1) or
          (FieldTypeCodeMgt.GetPerDiemDetailSystemFieldNo(FldCode) <> -1) or
          (FieldTypeCodeMgt.GetSettlementSystemFieldNo(FldCode) <> -1));
    end;


    procedure IsRequiredSystemField(Type: Integer): Boolean
    var
        ConfiguredField: Record "CEM Configured Field Type";
    begin
        case Type of
            ConfiguredField.Type::Expense:
                exit(FieldTypeCodeMgt.GetReqExpSystemFieldNo(Code) <> -1);

            ConfiguredField.Type::Mileage:
                exit(FieldTypeCodeMgt.GetReqMilSystemFieldNo(Code) <> -1);

            ConfiguredField.Type::"Per Diem":
                begin
                    if ConfiguredField."Sub Type" = ConfiguredField."Sub Type"::" " then
                        exit(FieldTypeCodeMgt.GetReqPerDiemSysFieldNo(Code) <> -1)
                    else
                        if ConfiguredField."Sub Type" = ConfiguredField."Sub Type"::Detail then
                            exit(FieldTypeCodeMgt.GetReqPerDiemDetailSysFieldNo(Code) <> -1);
                end;

            ConfiguredField.Type::Settlement:
                exit(FieldTypeCodeMgt.GetReqSettlementSysFieldNo(Code) <> -1);
        end;
    end;


    procedure CorrectDecimalPlacesFormat(var DecimalPlaces: Text[10]): Boolean
    var
        IntVar: Integer;
        Pos: Integer;
    begin
        if not FormatDecimalPlaces(DecimalPlaces) then
            exit(false);

        Pos := StrPos(DecimalPlaces, ':');
        if not (Pos = 2) then
            exit(false);

        if not Evaluate(IntVar, CopyStr(DecimalPlaces, 1, Pos - 1)) then
            exit(false);
        if (IntVar < 0) or (IntVar > 10) then
            exit(false);

        if not Evaluate(IntVar, CopyStr(DecimalPlaces, Pos + 1)) then
            exit(false);
        if (IntVar < 0) or (IntVar > 10) then
            exit(false);

        exit(true);
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
    var
        FieldType: Record "CEM Field Type";
        RecIDMgt: Codeunit "CDC Record ID Mgt.";
    begin
        FieldType.SetRange("Source Table No.", TableID);
        FieldType.SetRange("Source Field No.", RecIDMgt.GetFirstKeyField(TableID));
        if FieldType.FindFirst then
            exit(FieldType.Code);
    end;


    procedure IsSystemFieldForTable(TableID: Integer): Boolean
    begin
        case TableID of
            DATABASE::"CEM Expense", DATABASE::"CEM Expense Allocation":
                exit(FieldTypeCodeMgt.GetExpSystemFieldNo(Code) <> -1);
            DATABASE::"CEM Mileage":
                exit(FieldTypeCodeMgt.GetMilSystemFieldNo(Code) <> -1);
            DATABASE::"CEM Expense Header":
                exit(FieldTypeCodeMgt.GetSettlementSystemFieldNo(Code) <> -1);
            DATABASE::"CEM Per Diem":
                exit(FieldTypeCodeMgt.GetPerDiemSystemFieldNo(Code) <> -1);
        end;
    end;

    local procedure CheckFieldIsAllowedEditable()
    begin
        if not FieldTypeCodeMgt.CheckFieldIsAllowedEditable(Code) then
            Error(FieldNotAllowedEditableErr, TableCaption, Code);
    end;

    local procedure CreateFilterString(var LookupValueTemp: Record "CEM Lookup Value Temp") FilterString: Text[250]
    var
        FirstValueSet: Boolean;
    begin
        if LookupValueTemp.FindSet then
            repeat
                if FilterString <> '' then
                    FilterString += '|';
                FilterString += LookupValueTemp.Value;
            until LookupValueTemp.Next = 0;
    end;

    local procedure SaveOriginalSelection(var LookupValueTemp: Record "CEM Lookup Value Temp"; OriginalFilterString: Text[250]; FullFilterString: Text[250])
    var
        i: Integer;
        Index: Integer;
        FilterStringArray: array[100] of Text[1024];
    begin
        Split(OriginalFilterString, '|', FilterStringArray);

        for i := 1 to ArrayLen(FilterStringArray) do begin
            Index := ValueIsValidOption(FullFilterString, FilterStringArray[i]);
            if Index > -1 then begin
                LookupValueTemp.Get(Index);
                LookupValueTemp.Choose := true;
                LookupValueTemp.Modify;
            end;
        end;
    end;

    local procedure ValueIsValidOption(OptionAsText: Text[250]; Value: Text[250]): Integer
    var
        i: Integer;
        OptionsAsArray: array[100] of Text[1024];
    begin
        Split(OptionAsText, ',', OptionsAsArray);

        if Value = '' then
            exit(-1);

        for i := 1 to ArrayLen(OptionsAsArray) do begin
            if OptionsAsArray[i] = Value then
                exit(i);
        end;

        exit(-1);
    end;

    local procedure Split(Text: Text[1024]; Splitter: Text[1]; var TextArray: array[100] of Text[1024])
    var
        i: Integer;
        Index: Integer;
    begin
        i := StrPos(Text, Splitter);

        while (i <> 0) and (Index < 100) do begin
            Index := Index + 1;
            if i < MaxStrLen(TextArray[Index]) then
                TextArray[Index] := CopyStr(Text, 1, i - 1)
            else
                TextArray[Index] := CopyStr(Text, 1, MaxStrLen(TextArray[Index]));
            Text := CopyStr(Text, i + 1);
            i := StrPos(Text, Splitter);
        end;
        TextArray[Index + 1] := Text;
    end;


    procedure CheckLookupValuesOnCode()
    begin
        if Type = Type::Option then
            exit;

        if (Type <> Type::Code) and ("Source Table No." <> 0) then
            Error(LookupValuesAllowedOnCodeErr);
    end;


    procedure CheckLookupValuesLimit(FieldTypeCode: Code[20]; SkipConfiguredCheck: Boolean; var Warning: Text[1024]) MaximumLookupValuesDetected: Boolean
    var
        ConfiguredFieldType: Record "CEM Configured Field Type";
        FieldType: Record "CEM Field Type";
    begin
        Warning := '';
        FieldType.SetRange(Type, FieldType.Type::Code);
        if not (FieldTypeCode = '') then
            FieldType.SetRange(Code, FieldTypeCode);
        if FieldType.FindSet then
            repeat
                FieldType.CalcFields("No. of Lookup Values");
                if FieldType."No. of Lookup Values" > MaximumLookupValues then begin
                    ConfiguredFieldType.SetRange("Field Code", FieldType.Code);
                    if (not ConfiguredFieldType.IsEmpty) or SkipConfiguredCheck then begin
                        if Warning = '' then
                            Warning :=
                              CopyStr(
                                StrSubstNo(LookupValuesLine1Msg, FieldType.Code, Format(FieldType."No. of Lookup Values", 0, '<Integer Thousand>')),
                                1, MaxStrLen(Warning))
                        else
                            Warning :=
                              CopyStr(
                                Warning + ' ' +
                                StrSubstNo(LookupValuesLine1Msg, FieldType.Code, Format(FieldType."No. of Lookup Values", 0, '<Integer Thousand>')),
                                1, MaxStrLen(Warning));
                        MaximumLookupValuesDetected := true;
                    end;
                end;
            until FieldType.Next = 0;

        Warning := CopyStr(Warning + '\\' + LookupValuesLine2Msg + ' ' + LookupValuesLine3Msg, 1, MaxStrLen(Warning));
    end;

    local procedure MaximumLookupValues(): Integer
    begin
        exit(50000);
    end;


    procedure CreateFieldType(FieldCode: Code[20]; FieldDescription: Text[50]; FieldDataType: Integer; FieldLength: Integer; FieldMandatory: Boolean; SourceTableNo: Integer; SourceFieldNo: Integer; SourceDescriptionFieldNo: Integer)
    var
        FieldType: Record "CEM Field Type";
    begin
        if FieldType.Get(FieldCode) then begin
            FieldType.SetSkipSystemFieldCheck(true);
            FieldType.Delete(true);
        end;

        FieldType.Code := FieldCode;
        FieldType.Description := FieldDescription;
        FieldType.Type := FieldDataType;
        FieldType.Length := FieldLength;
        FieldType.Mandatory := FieldMandatory;
        FieldType."Source Table No." := SourceTableNo;
        FieldType."Source Field No." := SourceFieldNo;
        FieldType."Source Description Field No." := SourceDescriptionFieldNo;
        FieldType.Insert(true);

        if SourceTableNo <> 0 then
            FieldType.CalcLookupValForFieldAndParent(true);
    end;


    procedure SetSkipSystemFieldCheck(SkipSystemFieldCheck: Boolean)
    begin
        _SkipSystemFieldCheck := SkipSystemFieldCheck;
    end;
}

