import { attemptSignIn, attemptSignOut } from "@/actions";
import { ButtonHTMLAttributes } from "react";
import clsx from "clsx";
import Form from "next/form";

export const Button: React.FC<ButtonHTMLAttributes<HTMLButtonElement>> = (props) => {
  const { children, className, type } = props;

  const classNames = clsx(
    props.className,
    "rounded-sm",
    "md:rounded-md",
    "bg-white/20",
    "px-5",
    "py-2",
    "text-white",
    "hover:cursor-pointer",
    "hover:bg-white/30",
    "active:bg-white/35"
  );

  return (
    <button className={classNames} type={type}>
      {children}
    </button>
  )
}

export const SignInButton: React.FC<{ className?: string, containerClassName?: string }> = (props) => {
  const { className, containerClassName } = props;

  return (
    <Form action={attemptSignIn}>
      <Button type="submit" className={className}>Sign In</Button>
    </Form>
  )
}

export const SignOutButton: React.FC<{ className?: string, containerClassName?: string}> = (props) => {
  const { className, containerClassName } = props;

  return (
    <Form action={attemptSignOut} className={containerClassName}>
      <Button type="submit" className={className}>Sign Out</Button>
    </Form>
  )
}