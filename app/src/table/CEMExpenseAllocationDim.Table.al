table 6086357 "CEM Expense Allocation Dim."
{
    Caption = 'Expense Allocation Dimension';
    DataCaptionFields = "Expense Allocation Entry No.";

    fields
    {
        field(1; "Expense Allocation Entry No."; Integer)
        {
            Caption = 'Expense Allocation Entry No.';
            TableRelation = "CEM Expense Allocation";
        }
        field(2; "Dimension Code"; Code[20])
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
                    Error(DimMgt.GetDimErr());
            end;
        }
        field(3; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            NotBlank = true;
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Code"));

            trigger OnValidate()
            var
                ExpenseAllocation: Record "CEM Expense Allocation";
                GLSetup: Record "General Ledger Setup";
            begin
                GLSetup.Get();
                ExpenseAllocation.Get("Expense Allocation Entry No.");

                if "Dimension Code" in [GLSetup."Global Dimension 1 Code", GLSetup."Global Dimension 2 Code"] then begin
                    if "Dimension Code" = GLSetup."Global Dimension 1 Code" then
                        ExpenseAllocation."Global Dimension 1 Code" := "Dimension Value Code";

                    if "Dimension Code" = GLSetup."Global Dimension 2 Code" then
                        ExpenseAllocation."Global Dimension 2 Code" := "Dimension Value Code";
                end;

                ExpenseAllocation.Modified := true;
                ExpenseAllocation.Modify();
            end;
        }
        field(4; "Field Code"; Code[20])
        {
            Caption = 'Field Name';
            TableRelation = "CEM Field Type" where("System Field" = const(false),
                                                    "Source Table No." = filter(<> 349));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                FieldType: Record "CEM Field Type";
            begin
                if "Field Code" = '' then
                    exit;

                FieldType.Get("Field Code");
            end;
        }
        field(5; "Field Value"; Text[250])
        {
            Caption = 'Field Value';
            TableRelation = "CEM Lookup Value".Code where("Field Type Code" = field("Field Code"));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                EMDimension: Record "CEM Dimension";
                FieldType: Record "CEM Field Type";
                ResultOK: Boolean;
            begin
                if "Field Value" = '' then
                    exit;

                FieldType.Get("Field Code");
                ResultOK := EMDimension.ValidateFieldValue("Field Code", "Field Value");
                if not ResultOK then
                    if (FieldType.Type = FieldType.Type::Option) then
                        Error(EvaluateOptionErr, "Field Code", "Field Value")
                    else
                        Error(EvaluateErr, "Field Value", "Field Code", FieldType.Type);
            end;
        }
    }

    keys
    {
        key(Key1; "Expense Allocation Entry No.", "Dimension Code", "Field Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestNotPosted();
        UpdateRecordGlobalDimValue("Expense Allocation Entry No.", "Dimension Code", '');
    end;

    trigger OnInsert()
    begin
        TestNotPosted();
        UpdateRecordGlobalDimValue("Expense Allocation Entry No.", "Dimension Code", "Dimension Value Code");

        if ("Dimension Code" = '') and ("Field Code" = '') then
            Error('');
    end;

    trigger OnModify()
    begin
        TestNotPosted();
        UpdateRecordGlobalDimValue("Expense Allocation Entry No.", "Dimension Code", "Dimension Value Code");

        if ("Dimension Code" = '') and ("Field Code" = '') then
            Error('');
    end;

    trigger OnRename()
    begin
        Error(Text002, TableCaption);
    end;

    var
        EvaluateErr: Label 'Your entry of ''%1'' is not an acceptable value for ''%2''. The value ''%1'' can''t be evaluated into date type %3.';
        EvaluateOptionErr: Label 'The field %1 contains a value (%2) that cannot be found in the lookup values.';
        Text002: Label 'You cannot rename a %1.';

    local procedure TestNotPosted()
    var
        Expense: Record "CEM Expense";
        ExpenseAllocation: Record "CEM Expense Allocation";
    begin
        ExpenseAllocation.Get("Expense Allocation Entry No.");
        Expense.Get(ExpenseAllocation."Expense Entry No.");
        Expense.TestField(Posted, false);
    end;


    procedure GetFieldFromDim(Dim: Code[20]): Code[20]
    var
        FieldType: Record "CEM Field Type";
    begin
        exit(FieldType.GetFieldFromDim(Dim));
    end;


    procedure EMDimUpdated(var ExpAllocDim: Record "CEM Expense Allocation Dim."; AllocationEntryNo: Integer): Boolean
    var
        xExpAllocDim: Record "CEM Expense Allocation Dim.";
    begin
        ExpAllocDim.Reset();
        ExpAllocDim.SetRange("Expense Allocation Entry No.", AllocationEntryNo);

        xExpAllocDim.Reset();
        xExpAllocDim.SetRange("Expense Allocation Entry No.", AllocationEntryNo);

        if ExpAllocDim.FindSet() then
            repeat
                if not xExpAllocDim.Get(AllocationEntryNo, ExpAllocDim."Dimension Code", ExpAllocDim."Field Code") then
                    exit(true);

                if ExpAllocDim."Dimension Value Code" <> xExpAllocDim."Dimension Value Code" then
                    exit(true);

                if ExpAllocDim."Field Value" <> xExpAllocDim."Field Value" then
                    exit(true);

            until ExpAllocDim.Next() = 0;

        if xExpAllocDim.FindSet() then
            repeat
                if not ExpAllocDim.Get(AllocationEntryNo, xExpAllocDim."Dimension Code", xExpAllocDim."Field Code") then
                    exit(true);
            until xExpAllocDim.Next() = 0;
    end;

    local procedure UpdateRecordGlobalDimValue(AllocationEntryNo: Integer; DimCode: Code[20]; DimValCode: Code[20])
    var
        ExpAllocation: Record "CEM Expense Allocation";
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        if not (DimCode in [GLSetup."Global Dimension 1 Code", GLSetup."Global Dimension 2 Code"]) then
            exit;

        ExpAllocation.Get(AllocationEntryNo);
        if DimCode = GLSetup."Global Dimension 1 Code" then
            ExpAllocation."Global Dimension 1 Code" := DimValCode;
        if DimCode = GLSetup."Global Dimension 2 Code" then
            ExpAllocation."Global Dimension 2 Code" := DimValCode;
        ExpAllocation.Modify();
    end;
}

