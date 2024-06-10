table 6086334 "CEM Configured Field Type"
{
    Caption = 'Configured Field Type';
    DataCaptionFields = "Field Code", "Field Description";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Expense,Mileage,Settlement,Per Diem';
            OptionMembers = Expense,Mileage,Settlement,"Per Diem";

            trigger OnValidate()
            begin
                CheckVehicleRegNo;
            end;
        }
        field(2; "Sub Type"; Option)
        {
            Caption = 'Sub Type';
            OptionMembers = " ",Detail;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            MinValue = 1;
        }
        field(10; "Field Code"; Code[20])
        {
            Caption = 'Field Code';
            TableRelation = "CEM Field Type";

            trigger OnValidate()
            var
                ConfiguredFieldType: Record "CEM Configured Field Type";
                FieldType: Record "CEM Field Type";
            begin
                if not FieldType.Get("Field Code") then
                    exit;

                if FieldType.GetParentFieldTypeCode <> '' then begin
                    ConfiguredFieldType.SetRange(Type, Type);
                    ConfiguredFieldType.SetRange("Sub Type", "Sub Type");
                    ConfiguredFieldType.SetRange("Field Code", FieldType.GetParentFieldTypeCode);
                    if ConfiguredFieldType.IsEmpty then
                        Error(RelatedFieldMissingErr, "Field Code", FieldType.TableCaption, FieldType.GetParentFieldTypeCode, "Field Code");
                end;

                CheckVehicleRegNo;
            end;
        }
        field(11; "Field Description"; Text[50])
        {
            CalcFormula = Lookup("CEM Field Type".Description WHERE(Code = FIELD("Field Code")));
            Caption = 'Field Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Sent to Continia Online"; Boolean)
        {
            Caption = 'Sent to Continia Online';
            Editable = false;
        }
        field(23; "Hide visibility by default"; Boolean)
        {
            Caption = 'Hide visibility by default';
        }
        field(30; "Field Dependencies"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count("CEM Field Type Dependency" WHERE("Field Type Code" = FIELD("Field Code")));
            Caption = 'Field Dependencies';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Type, "Sub Type", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ConfigField: Record "CEM Configured Field Type";
        FieldType: Record "CEM Field Type";
        FieldTypeDependency: Record "CEM Field Type Dependency";
    begin
        ForceFieldUpdateInCO;

        if not FieldType.Get("Field Code") then
            exit;

        GetEMSetup;
        if (FieldType.IsRequiredSystemField(Type)) and (not SkipSystemFieldCheck) then
            if (Type = Type::Expense) or
              (EMSetup."Enable Mileage" and (Type = Type::Mileage)) or
              (EMSetup."Enable Per Diem" and (Type = Type::"Per Diem")) or
              (EMSetup.SettlementEnabled) and (Type = Type::Settlement)
            then
                Error(NotAllowedToDeleteSysFieldErr, "Field Code");

        ConfigField.SetRange(Type, Type);
        ConfigField.SetRange("Sub Type", "Sub Type");
        ConfigField.SetFilter("Field Code", '<>%1', "Field Code");
        if ConfigField.FindSet then
            repeat
                FieldType.Get(ConfigField."Field Code");
                if FieldType.GetParentFieldTypeCode = "Field Code" then
                    Error(UnableToDeleteErr, FieldType.TableCaption, FieldCaption("Field Code"), FieldType.Code);
            until ConfigField.Next = 0;

        FieldTypeDependency.DeleteDependenciesNotNeeded(Type, "Field Code");
    end;

    trigger OnInsert()
    var
        FieldType: Record "CEM Field Type";
        Warning: Text[1024];
    begin
        CheckConfFieldExists;
        ForceFieldUpdateInCO;
        CheckTaxAreaAllowed;
        CheckTaxGroupAllowed;
        CheckPreApprovalAllowed;
        if FieldType.CheckLookupValuesLimit("Field Code", true, Warning) then
            Message(Warning);
    end;

    trigger OnModify()
    begin
        CheckConfFieldExists;
        ForceFieldUpdateInCO;
        CheckTaxAreaAllowed;
        CheckTaxGroupAllowed;
        CheckPreApprovalAllowed;
    end;

    trigger OnRename()
    begin
        if (Type <> xRec.Type) or ("Sub Type" <> xRec."Sub Type") then
            Error(UnableToRenameErr, TableCaption);
    end;

    var
        EMSetup: Record "CEM Expense Management Setup";
        GotEMSetup: Boolean;
        SkipAllowedFieldCheck: Boolean;
        SkipSystemFieldCheck: Boolean;
        BothFromAndToHomeErr: Label 'Both %1 and %2 fields must be configured.';
        CanadaSalesTaxFieldErr: Label '%1 can only be used for Canada Sales Tax calculation.';
        ConfFieldTypeNotFound: Label 'Could not identify a %1 %2 for table %3.';
        DimensionValueFilterErr: Label 'Field Type %1 does not have a dimension code specified. Please specify a dimension code filter in the %2 and synchronize again.';
        FieldAlreadyExists: Label '%1 - %2 already exists.';
        MissingMandatoryFieldErr: Label '%1 requires the following fields to be configured: %2.';
        NotAllowedToDeleteSysFieldErr: Label 'You are not allowed to delete a system field: %1';
        PreApprovalFieldErr: Label '%1 requires the feature to be enabled from the %2.';
        RelatedFieldMissingErr: Label '%1 has a relationship to %2 %3 which must also be added before you can add %4.';
        UnableToDeleteErr: Label '%1 cannot be deleted as there is a relationship to %2 %3.';
        UnableToRenameErr: Label 'You cannot rename a %1.';
        VehTypeMustBeDiffTxt: Label '%1 must be %2 for %3.';


    procedure GetEMSetup()
    begin
        if not GotEMSetup then
            EMSetup.Get;

        GotEMSetup := true;
    end;

    local procedure ForceFieldUpdateInCO()
    begin
        GetEMSetup;
        if not EMSetup."Force Field Update in CO" then begin
            EMSetup."Force Field Update in CO" := true;
            EMSetup.Modify;
        end;
    end;


    procedure AttendeesEnabledFor(TableID: Integer): Boolean
    var
        ConfiguredField: Record "CEM Configured Field Type";
        FieldType: Record "CEM Field Type";
    begin
        case TableID of
            DATABASE::"CEM Expense":
                Type := Type::Expense;
            DATABASE::"CEM Mileage":
                Type := Type::Mileage;
            DATABASE::"CEM Expense Header":
                Type := Type::Settlement;
        end;

        FieldType.SetRange(Type, FieldType.Type::Attendees);
        if FieldType.FindFirst then begin
            ConfiguredField.SetRange(Type, Type);
            ConfiguredField.SetRange("Sub Type", "Sub Type");
            ConfiguredField.SetRange("Field Code", FieldType.Code);
            if not ConfiguredField.IsEmpty then
                exit(true);
        end;
    end;

    local procedure CheckConfFieldExists()
    var
        ConfiguredField: Record "CEM Configured Field Type";
    begin
        TestField("Field Code");
        ConfiguredField.SetRange(Type, Type);
        ConfiguredField.SetRange("Sub Type", "Sub Type");
        ConfiguredField.SetRange("Field Code", "Field Code");
        ConfiguredField.SetFilter("Line No.", '<>%1', "Line No.");
        if not ConfiguredField.IsEmpty then
            Error(FieldAlreadyExists, TableCaption, "Field Code");
    end;


    procedure IsConfiguredFieldForTable(TableID: Integer; FieldCode: Code[20]): Boolean
    var
        ConfiguredField: Record "CEM Configured Field Type";
    begin
        case TableID of
            DATABASE::"CEM Expense":
                ConfiguredField.Type := ConfiguredField.Type::Expense;
            DATABASE::"CEM Mileage":
                ConfiguredField.Type := ConfiguredField.Type::Mileage;
            DATABASE::"CEM Expense Header":
                ConfiguredField.Type := ConfiguredField.Type::Settlement;
            DATABASE::"CEM Per Diem":
                begin
                    ConfiguredField.Type := ConfiguredField.Type::"Per Diem";
                    ConfiguredField."Sub Type" := ConfiguredField."Sub Type"::" ";
                end;

            DATABASE::"CEM Per Diem Detail":
                begin
                    ConfiguredField.Type := ConfiguredField.Type::"Per Diem";
                    ConfiguredField."Sub Type" := ConfiguredField."Sub Type"::Detail;
                end;
        end;

        ConfiguredField.SetRange(Type, ConfiguredField.Type);
        ConfiguredField.SetRange("Sub Type", ConfiguredField."Sub Type");
        ConfiguredField.SetRange("Field Code", FieldCode);
        exit(not ConfiguredField.IsEmpty);
    end;


    procedure MoveUp()
    begin
        SwapLines(-1);
    end;


    procedure MoveDown()
    begin
        SwapLines(1);
    end;

    local procedure SwapLines(Direction: Integer)
    var
        ConfiguredField1: Record "CEM Configured Field Type";
        ConfiguredField2: Record "CEM Configured Field Type";
        ConfiguredFieldCurrent: Record "CEM Configured Field Type";
        ConfiguredFieldTemp: Record "CEM Configured Field Type";
    begin
        ConfiguredFieldCurrent := Rec;

        if "Line No." <= 0 then
            exit;

        ConfiguredField2.Get(Type, "Sub Type", "Line No.");

        ConfiguredField1.Reset;
        ConfiguredField1.SetRange(Type, Type);
        ConfiguredField1.SetRange("Sub Type", "Sub Type");
        case Direction of
            1:
                begin
                    ConfiguredField1.SetFilter("Line No.", '>%1', "Line No.");
                    if not ConfiguredField1.FindFirst then
                        exit;
                end;
            -1:
                begin
                    ConfiguredField1.SetFilter("Line No.", '<%1', "Line No.");
                    if not ConfiguredField1.FindLast then
                        exit;
                end;
            else
                exit;
        end;

        if not ((ConfiguredField1.Type = ConfiguredField2.Type) and
          (ConfiguredField1."Sub Type" = ConfiguredField2."Sub Type")) then begin
            Get(ConfiguredFieldCurrent.Type, ConfiguredFieldCurrent."Sub Type", ConfiguredFieldCurrent."Line No.");
            exit;
        end;

        ConfiguredFieldTemp := ConfiguredField1;
        ConfiguredField1.TransferFields(ConfiguredField2, false);
        ConfiguredField1.Modify;

        ConfiguredField2.TransferFields(ConfiguredFieldTemp, false);
        ConfiguredField2.Modify;

        ForceFieldUpdateInCO;

        Get(ConfiguredFieldTemp.Type, ConfiguredFieldTemp."Sub Type", ConfiguredFieldTemp."Line No.");
    end;

    local procedure CheckVehicleRegNo()
    var
        FieldType: Record "CEM Field Type";
    begin
        if not FieldType.Get("Field Code") then
            exit;

        if "Field Code" = 'VEHICLE REG. NO.' then
            if Type <> Type::Mileage then begin
                Type := Type::Mileage;
                Error(VehTypeMustBeDiffTxt, FieldCaption(Type), Format(Type), FieldType.Description);
            end;
    end;


    procedure CheckExpenseMandatoryFields()
    var
        ConfigField: Record "CEM Configured Field Type";
    begin
        CheckFieldsAreConfigured(
          ConfigField.Type::Expense, 4, StrSubstNo('%1|%2|%3|%4', 'DOCUMENT DATE', 'CURRENCY', 'AMOUNT', 'EXPENSE TYPE'));
    end;


    procedure CheckMileageMandatoryFields()
    var
        ConfigField: Record "CEM Configured Field Type";
        MandatoryFieldsNumber: Integer;
    begin
        GetEMSetup;
        if not EMSetup."Enable Mileage" then
            exit;

        CheckFieldsAreConfigured(ConfigField.Type::Mileage, 5,
          StrSubstNo('%1|%2|%3|%4|%5', 'DOCUMENT DATE', 'DESCRIPTION', 'FROM', 'TO', 'DISTANCE'));
    end;


    procedure CheckMilFromAndToConfigured()
    var
        ConfigField: Record "CEM Configured Field Type";
        FieldTypeCodeMgt: Codeunit "CEM Field Type Code Mgt.";
    begin
        GetEMSetup;
        if not EMSetup."Enable Mileage" then
            exit;

        ConfigField.SetRange(Type, ConfigField.Type::Mileage);
        ConfigField.SetFilter("Field Code", '%1|%2', FieldTypeCodeMgt.GetFromHomeCode, FieldTypeCodeMgt.GetToHomeCode);
        if ConfigField.Count = 1 then
            Error(BothFromAndToHomeErr, FieldTypeCodeMgt.GetFromHomeCode, FieldTypeCodeMgt.GetToHomeCode);
    end;


    procedure CheckPerDiemMandatoryFields()
    var
        ConfigField: Record "CEM Configured Field Type";
    begin
        GetEMSetup;
        if not EMSetup."Enable Per Diem" then
            exit;

        CheckFieldsAreConfigured(
          ConfigField.Type::"Per Diem", 3, StrSubstNo('%1|%2|%3', 'P-DESCRIPTION', 'P-DEPARTURE DATETIME', 'P-RETURN DATETIME'));
    end;


    procedure CheckSettlementMandatoryFields()
    var
        ConfigField: Record "CEM Configured Field Type";
    begin
        GetEMSetup;
        if not EMSetup.SettlementEnabled then
            exit;

        CheckFieldsAreConfigured(ConfigField.Type::Settlement, 1, 'DESCRIPTION');
    end;

    local procedure CheckFieldsAreConfigured(ConfigFieldType: Option; MandatoryFieldsNumber: Integer; FieldCodeFilter: Text[250])
    var
        ConfigField: Record "CEM Configured Field Type";
    begin
        ConfigField.SetRange(Type, ConfigFieldType);
        ConfigField.SetRange("Sub Type", ConfigField."Sub Type"::" ");
        ConfigField.SetFilter("Field Code", FieldCodeFilter);

        if ConfigField.Count < MandatoryFieldsNumber then
            Error(MissingMandatoryFieldErr, ConfigField.GetFilter(Type), ConfigField.GetFilter("Field Code"));
    end;


    procedure ConfigFieldActive(TableID: Integer; "Code": Code[20]): Boolean
    var
        ConfigField: Record "CEM Configured Field Type";
        EMDim: Record "CEM Dimension";
        FieldType: Record "CEM Field Type";
        ConfigType: Integer;
    begin
        case TableID of
            DATABASE::"CEM Expense":
                ConfigType := ConfigField.Type::Expense;
            DATABASE::"CEM Mileage":
                ConfigType := ConfigField.Type::Mileage;
            DATABASE::"CEM Expense Header":
                ConfigType := ConfigField.Type::Settlement;
            DATABASE::"CEM Per Diem", DATABASE::"CEM Per Diem Detail":
                ConfigType := ConfigField.Type::"Per Diem";
            else
                Error(ConfFieldTypeNotFound, ConfigField.TableCaption, ConfigField.FieldCaption(Type), TableID);
        end;

        ConfigField.SetRange(Type, ConfigType);
        ConfigField.SetRange("Field Code", Code);
        if not ConfigField.IsEmpty then
            exit(true);

        FieldType.Code := EMDim.GetFieldFromDim(Code);
        if FieldType.Code = '' then
            exit(false);

        ConfigField.SetRange("Field Code", FieldType.Code);
        exit(not ConfigField.IsEmpty);
    end;

    local procedure CheckTaxAreaAllowed()
    var
        FieldTypeCodeMgt: Codeunit "CEM Field Type Code Mgt.";
        SalesTaxInferface: Codeunit "CEM Sales Tax Interface";
    begin
        if "Field Code" <> FieldTypeCodeMgt.GetTaxAreaCode then
            exit;

        if not SalesTaxInferface.ShouldHandleCASalesTax then
            Error(CanadaSalesTaxFieldErr, FieldTypeCodeMgt.GetTaxAreaCode);
    end;

    local procedure CheckTaxGroupAllowed()
    var
        FieldTypeCodeMgt: Codeunit "CEM Field Type Code Mgt.";
        SalesTaxInferface: Codeunit "CEM Sales Tax Interface";
    begin
        if "Field Code" <> FieldTypeCodeMgt.GetTaxGroupCode then
            exit;

        if not SalesTaxInferface.ShouldHandleCASalesTax then
            Error(CanadaSalesTaxFieldErr, FieldTypeCodeMgt.GetTaxGroupCode);
    end;

    local procedure CheckPreApprovalAllowed()
    var
        FieldTypeCodeMgt: Codeunit "CEM Field Type Code Mgt.";
    begin
        if ("Field Code" <> FieldTypeCodeMgt.GetSettPreApprovalAmountCode) or SkipAllowedFieldCheck then
            exit;

        EMSetup.Get;
        if EMSetup."Settlement Pre-approval" = EMSetup."Settlement Pre-approval"::Disabled then
            Error(PreApprovalFieldErr, FieldTypeCodeMgt.GetSettPreApprovalAmountCode, EMSetup.TableCaption);
    end;


    procedure ConfigureFieldForTable(TableID: Integer; FieldCode: Code[20]; LineExpected: Integer): Boolean
    var
        ConfiguredField: Record "CEM Configured Field Type";
        i: Integer;
        NoOfFields: Integer;
    begin
        if IsConfiguredFieldForTable(TableID, FieldCode) then
            exit;

        case TableID of
            DATABASE::"CEM Expense":
                ConfiguredField.SetRange(Type, Type::Expense);
            DATABASE::"CEM Mileage":
                ConfiguredField.SetRange(Type, Type::Mileage);
            DATABASE::"CEM Expense Header":
                ConfiguredField.SetRange(Type, Type::Settlement);
            DATABASE::"CEM Per Diem":
                begin
                    ConfiguredField.SetRange(Type, Type::"Per Diem");
                    ConfiguredField.SetRange("Sub Type", ConfiguredField."Sub Type"::" ");
                end;
            DATABASE::"CEM Per Diem Detail":
                begin
                    ConfiguredField.SetRange(Type, Type::"Per Diem");
                    ConfiguredField.SetRange("Sub Type", ConfiguredField."Sub Type"::Detail);
                end;
        end;
        NoOfFields := ConfiguredField.Count;
        ConfiguredField.FindLast;

        Init;
        "Line No." := ConfiguredField."Line No." + 10000;
        "Field Code" := FieldCode;
        case TableID of
            DATABASE::"CEM Expense":
                Validate(Type, Type::Expense);
            DATABASE::"CEM Mileage":
                Validate(Type, Type::Mileage);
            DATABASE::"CEM Expense Header":
                Validate(Type, Type::Settlement);
            DATABASE::"CEM Per Diem":
                begin
                    Validate(Type, Type::"Per Diem");
                    Validate("Sub Type", "Sub Type"::" ");
                end;
            DATABASE::"CEM Per Diem Detail":
                begin
                    Validate(Type, Type::"Per Diem");
                    Validate("Sub Type", "Sub Type"::Detail);
                end;
        end;

        Insert(true);

        // Position the field
        if LineExpected <> 0 then begin
            repeat
                i += 1;
                MoveUp;
                if "Line No." <= LineExpected then
                    i := NoOfFields;
            until i = NoOfFields;
        end;
    end;


    procedure UnConfigureFieldForTable(TableID: Integer; FieldCode: Code[20]; SkipSystemFieldCheck: Boolean): Boolean
    var
        ConfiguredField: Record "CEM Configured Field Type";
    begin
        case TableID of
            DATABASE::"CEM Expense":
                ConfiguredField.SetRange(Type, Type::Expense);
            DATABASE::"CEM Mileage":
                ConfiguredField.SetRange(Type, Type::Mileage);
            DATABASE::"CEM Expense Header":
                ConfiguredField.SetRange(Type, Type::Settlement);
            DATABASE::"CEM Per Diem", DATABASE::"CEM Per Diem Detail":
                ConfiguredField.SetRange(Type, Type::"Per Diem");
        end;

        ConfiguredField.SetRange("Field Code", FieldCode);
        if ConfiguredField.FindFirst then
            ConfiguredField.Delete;
    end;


    procedure CheckDimensionFieldsFilter()
    var
        ConfiguredFieldType: Record "CEM Configured Field Type";
        FieldType: Record "CEM Field Type";
    begin
        if not GuiAllowed then
            exit;

        FieldType.SetRange("Source Table No.", DATABASE::"Dimension Value");
        if FieldType.FindSet then
            repeat
                if FieldType.GetDimCode = '' then begin
                    ConfiguredFieldType.SetRange("Field Code", FieldType.Code);
                    if not ConfiguredFieldType.IsEmpty then
                        Error(DimensionValueFilterErr, FieldType.Code, FieldType.FieldCaption("No. of Source Table Filters"));
                end;
            until FieldType.Next = 0;
    end;


    procedure SetSkipSytemFieldCheck(_NewSkipSystemFieldCheck: Boolean)
    begin
        SkipSystemFieldCheck := _NewSkipSystemFieldCheck;
    end;


    procedure SetSkipAllowedFieldCheck(_NewSkipAllowedFieldCheck: Boolean)
    begin
        SkipAllowedFieldCheck := _NewSkipAllowedFieldCheck;
    end;
}

