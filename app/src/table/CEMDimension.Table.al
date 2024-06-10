table 6086360 "CEM Dimension"
{
    Caption = 'EM Dimension';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Budget,Settlement';
            OptionMembers = Budget,Settlement;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Doc. Ref. No."; Integer)
        {
            Caption = 'Doc. Ref. No.';
            TableRelation = IF ("Table ID" = CONST(6086320)) "CEM Expense"
            ELSE
            IF ("Table ID" = CONST(6086338)) "CEM Mileage";
        }
        field(10; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            TableRelation = Dimension;

            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                if "Dimension Code" = '' then
                    exit;

                if not DimMgt.CheckDim("Dimension Code") then
                    Error(DimMgt.GetDimErr);
            end;
        }
        field(11; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            NotBlank = true;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"));

            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                if not DimMgt.CheckDimValue("Dimension Code", "Dimension Value Code") then
                    Error(DimMgt.GetDimErr);
            end;
        }
        field(12; "Field Code"; Code[20])
        {
            Caption = 'Field Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false),
                                                    "Source Table No." = FILTER(<> 349));

            trigger OnValidate()
            var
                FieldType: Record "CEM Field Type";
            begin
                if "Field Code" = '' then
                    exit;

                FieldType.Get("Field Code");
            end;
        }
        field(20; "Field Value"; Text[250])
        {
            Caption = 'Field Value';
            TableRelation = "CEM Lookup Value".Code WHERE("Field Type Code" = FIELD("Field Code"));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                FieldType: Record "CEM Field Type";
                ResultOK: Boolean;
            begin
                if "Field Value" = '' then
                    exit;

                FieldType.Get("Field Code");
                ResultOK := ValidateFieldValue("Field Code", "Field Value");
                if not ResultOK then
                    if (FieldType.Type = FieldType.Type::Option) then
                        Error(EvaluateOptionErr, "Field Code", FieldType.Type, ListOfPossibleOptions("Field Code"), "Field Value")
                    else
                        Error(EvaluateErr, "Field Code", FieldType.Type, "Field Value");
            end;
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document Type", "Document No.", "Doc. Ref. No.", "Dimension Code", "Field Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestNotPosted;
        UpdateRecordDimValue("Table ID", "Document Type", "Document No.", "Doc. Ref. No.", "Dimension Code", '');
    end;

    trigger OnInsert()
    begin
        TestNotPosted;
        UpdateRecordDimValue("Table ID", "Document Type", "Document No.", "Doc. Ref. No.", "Dimension Code", "Dimension Value Code");

        if ("Dimension Code" = '') and ("Field Code" = '') then
            Error('');
    end;

    trigger OnModify()
    begin
        TestNotPosted;
        UpdateRecordDimValue("Table ID", "Document Type", "Document No.", "Doc. Ref. No.", "Dimension Code", "Dimension Value Code");

        if ("Dimension Code" = '') and ("Field Code" = '') then
            Error('');
    end;

    trigger OnRename()
    begin
        Error(Text002, TableCaption);
    end;

    var
        IgnorePostedCheck: Boolean;
        EvaluateErr: Label 'The field %1 expects the value to be of data type %2. Field value %3 could not be evaluated as %2.';
        EvaluateOptionErr: Label 'The field %1 is of data type %2. The possible values are %3. %4 was not found in the list.';
        MaxLengthMsg: Label '%1 field can only contain %2 characters.';
        SpecifyParentFieldErr: Label 'You must specify a value for %1.';
        Text002: Label 'You cannot rename a %1.';

    local procedure TestNotPosted()
    var
        Expense: Record "CEM Expense";
        ExpHeader: Record "CEM Expense Header";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
    begin
        if IgnorePostedCheck then
            exit;

        case "Table ID" of

            DATABASE::"CEM Expense":
                begin
                    Expense.Get("Doc. Ref. No.");
                    Expense.TestField(Posted, false);
                    Expense.TestStatusOrUserAllowsChange;
                end;

            DATABASE::"CEM Mileage":
                begin
                    Mileage.Get("Doc. Ref. No.");
                    Mileage.TestField(Posted, false);
                    Mileage.TestStatusOrUserAllowsChange;
                end;

            DATABASE::"CEM Per Diem":
                begin
                    PerDiem.Get("Doc. Ref. No.");
                    PerDiem.TestField(Posted, false);
                    PerDiem.TestStatusOrUserAllowsChange;
                end;

            DATABASE::"CEM Expense Header":
                begin
                    ExpHeader.Get("Document Type", "Document No.");
                    ExpHeader.TestField(Posted, false);
                    ExpHeader.TestStatusOrUserAllowsChange;
                end;
        end;
    end;


    procedure ValidateFieldValue(FieldCode: Code[20]; var FieldValue: Text[250]) ResultOK: Boolean
    begin
    end;

    procedure DateTimeFormatString(): Text[250]
    begin
        exit('<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>');
    end;


    procedure DecimalFormatString(DecimalPlaces: Code[10]): Text[250]
    begin
        exit(StrSubstNo('<Precision,%1><Standard Format,9>', DecimalPlaces));
    end;


    procedure RemoveLeadingAndTrailingSpaces(String: Text[250]) Result: Text[250]
    begin
        Result := DelChr(String, '<', ' ');
        Result := DelChr(Result, '>', ' ');
    end;


    procedure LimitToMaxLength(FieldCode: Code[20]; String: Text[250]; MaxLength: Integer): Text[250]
    begin
        if (MaxLength > 0) and (MaxLength < StrLen(String)) then begin
            Message(MaxLengthMsg, FieldCode, MaxLength);
            exit(CopyStr(String, 1, MaxLength));
        end;

        exit(String);
    end;


    procedure ListOfPossibleOptions(FieldCode: Code[20]) PossibleOptions: Text
    var
        LookupValue: Record "CEM Lookup Value";
    begin
        LookupValue.SetRange("Field Type Code", FieldCode);
        if LookupValue.FindFirst then
            repeat
                if PossibleOptions = '' then
                    PossibleOptions := LookupValue.Code
                else
                    PossibleOptions += ', ' + LookupValue.Code;
            until LookupValue.Next = 0;
    end;


    procedure LookupFieldValue(FieldCode: Code[20]; var Text: Text[1024]): Boolean
    var
        EMDim: Record "CEM Dimension";
        FieldType: Record "CEM Field Type";
        LookupValue: Record "CEM Lookup Value";
        ParentFieldTypeCode: Code[20];
    begin
        LookupValue.SetRange("Field Type Code", FieldCode);

        FieldType.Get(FieldCode);
        ParentFieldTypeCode := FieldType.GetParentFieldTypeCode;
        if ParentFieldTypeCode <> '' then begin
            if not EMDim.Get(DATABASE::"CEM Expense", "Document Type", "Document No.", "Doc. Ref. No.", '', ParentFieldTypeCode) then
                Error(SpecifyParentFieldErr, ParentFieldTypeCode);

            EMDim.Get(DATABASE::"CEM Expense", "Document Type", "Document No.", "Doc. Ref. No.", '', ParentFieldTypeCode);
            LookupValue.SetRange("Parent Field Type Code", EMDim."Field Value");
        end;

        if PAGE.RunModal(0, LookupValue) = ACTION::LookupOK then begin
            Text := LookupValue.Code;
            exit(true);
        end;
    end;


    procedure GetFieldFromDim(Dim: Code[20]): Code[20]
    var
        FieldType: Record "CEM Field Type";
    begin
        exit(FieldType.GetFieldFromDim(Dim));
    end;

    local procedure UpdateRecordDimValue(TableID: Integer; DocumentType: Integer; DocumentNo: Code[20]; DocRefNo: Integer; DimCode: Code[20]; DimValCode: Code[20])
    var
        Expense: Record "CEM Expense";
        ExpHeader: Record "CEM Expense Header";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get;
        if not (DimCode in [GLSetup."Global Dimension 1 Code", GLSetup."Global Dimension 2 Code"]) then
            exit;

        case TableID of
            DATABASE::"CEM Expense":
                begin
                    Expense.Get(DocRefNo);
                    if DimCode = GLSetup."Global Dimension 1 Code" then
                        Expense."Global Dimension 1 Code" := DimValCode;
                    if DimCode = GLSetup."Global Dimension 2 Code" then
                        Expense."Global Dimension 2 Code" := DimValCode;
                    Expense.Modify;
                end;

            DATABASE::"CEM Mileage":
                begin
                    Mileage.Get(DocRefNo);
                    if DimCode = GLSetup."Global Dimension 1 Code" then
                        Mileage."Global Dimension 1 Code" := DimValCode;
                    if DimCode = GLSetup."Global Dimension 2 Code" then
                        Mileage."Global Dimension 2 Code" := DimValCode;
                    Mileage.Modify;
                end;

            DATABASE::"CEM Per Diem":
                begin
                    PerDiem.Get(DocRefNo);
                    if DimCode = GLSetup."Global Dimension 1 Code" then
                        PerDiem."Global Dimension 1 Code" := DimValCode;
                    if DimCode = GLSetup."Global Dimension 2 Code" then
                        PerDiem."Global Dimension 2 Code" := DimValCode;
                    PerDiem.Modify;
                end;

            DATABASE::"CEM Expense Header":
                begin
                    ExpHeader.Get(DocumentType, DocumentNo);
                    if DimCode = GLSetup."Global Dimension 1 Code" then
                        ExpHeader."Global Dimension 1 Code" := DimValCode;
                    if DimCode = GLSetup."Global Dimension 2 Code" then
                        ExpHeader."Global Dimension 2 Code" := DimValCode;
                    ExpHeader.Modify;
                end;

        end;
    end;


    procedure EMDimUpdated(var EMDim: Record "CEM Dimension"; TableID: Integer; DocType: Integer; DocNo: Code[20]; DocRefNo: Integer): Boolean
    var
        xEMDim: Record "CEM Dimension";
    begin
        EMDim.Reset;
        EMDim.SetRange("Table ID", TableID);
        EMDim.SetRange("Document Type", DocType);
        EMDim.SetRange("Document No.", DocNo);
        EMDim.SetRange("Doc. Ref. No.", DocRefNo);

        xEMDim.Reset;
        xEMDim.SetRange("Table ID", TableID);
        xEMDim.SetRange("Document Type", DocType);
        xEMDim.SetRange("Document No.", DocNo);
        xEMDim.SetRange("Doc. Ref. No.", DocRefNo);

        if EMDim.FindSet then
            repeat
                if not xEMDim.Get(TableID, DocType, DocNo, DocRefNo, EMDim."Dimension Code", EMDim."Field Code") then
                    exit(true);

                if (EMDim."Dimension Value Code" <> xEMDim."Dimension Value Code") or (EMDim."Field Value" <> xEMDim."Field Value") then
                    exit(true);
            until EMDim.Next = 0;

        if xEMDim.FindSet then
            repeat
                if not EMDim.Get(TableID, DocType, DocNo, DocRefNo, xEMDim."Dimension Code", xEMDim."Field Code") then
                    exit(true);
            until xEMDim.Next = 0;
    end;


    procedure IgnoreTestPosted(NewIgnorePostedCheck: Boolean)
    begin
        IgnorePostedCheck := NewIgnorePostedCheck;
    end;
}

