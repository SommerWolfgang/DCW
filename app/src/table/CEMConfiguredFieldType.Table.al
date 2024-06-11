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
        }
        field(11; "Field Description"; Text[50])
        {
            CalcFormula = lookup("CEM Field Type".Description where(Code = field("Field Code")));
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
            CalcFormula = count("CEM Field Type Dependency" where("Field Type Code" = field("Field Code")));
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
    procedure GetEMSetup()
    begin
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
        if FieldType.FindFirst() then begin
            ConfiguredField.SetRange(Type, Type);
            ConfiguredField.SetRange("Sub Type", "Sub Type");
            ConfiguredField.SetRange("Field Code", FieldType.Code);
            if not ConfiguredField.IsEmpty then
                exit(true);
        end;
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
    end;


    procedure MoveDown()
    begin
    end;

    procedure CheckExpenseMandatoryFields()
    begin
    end;

    procedure CheckMileageMandatoryFields()
    begin
    end;

    procedure CheckMilFromAndToConfigured()
    begin
    end;

    procedure CheckPerDiemMandatoryFields()
    begin
    end;


    procedure CheckSettlementMandatoryFields()
    begin
    end;

    procedure ConfigFieldActive(TableID: Integer; "Code": Code[20]): Boolean
    begin
    end;

    procedure ConfigureFieldForTable(TableID: Integer; FieldCode: Code[20]; LineExpected: Integer): Boolean
    begin
    end;

    procedure UnConfigureFieldForTable(TableID: Integer; FieldCode: Code[20]; SkipSystemFieldCheck: Boolean): Boolean
    begin
    end;

    procedure CheckDimensionFieldsFilter()
    begin
    end;

    procedure SetSkipSytemFieldCheck(_NewSkipSystemFieldCheck: Boolean)
    begin
    end;

    procedure SetSkipAllowedFieldCheck(_NewSkipAllowedFieldCheck: Boolean)
    begin
    end;
}