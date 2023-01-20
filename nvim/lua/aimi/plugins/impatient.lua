local status_ok, impatient = pcall(require, "impatient")
if not status_ok then
    error("Load [impatient] Failed!")
    return
end

impatient.enable_profile()
